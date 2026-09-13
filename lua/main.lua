local function write_log(message)
    if type(_G.log) == "function" then
        _G.log("[PD2CCF] " .. tostring(message))
    end
end

local state = rawget(_G, "PD2CCF_EngineLock_State")
if not state then
    state = {
        initialized = false,
        disabled = false,
        locking = false,
        mouse = nil
    }
    _G.PD2CCF_EngineLock_State = state
else
    state.disabled = state.disabled or false
end

local function call_method(object, method_name, ...)
    local method = object and object[method_name]
    if type(method) ~= "function" then
        return false, "missing method: " .. method_name
    end

    return pcall(method, object, ...)
end

local function get_mouse()
    if not Input or type(Input.mouse) ~= "function" then
        return nil
    end

    local ok, mouse = pcall(function()
        return Input:mouse()
    end)

    return ok and mouse or nil
end

local function frame_is_active()
    if not Global or not Global.frame then
        return false
    end

    local ok, active = pcall(function()
        return Global.frame:is_active()
    end)

    return ok and active == true
end

local function player_is_active()
    if not managers or not managers.player then
        return false
    end

    local ok, unit = pcall(function()
        return managers.player:player_unit()
    end)

    return ok and unit ~= nil and alive(unit)
end

local function menu_is_open()
    if not managers or not managers.menu then
        return false
    end

    local ok, menu = pcall(function()
        return managers.menu:active_menu()
    end)

    return ok and menu ~= nil
end

local function set_mouse_lock(mouse, locked)
    return call_method(mouse, "set_lock_mouse", locked)
end

local function release_lock(self, current_mouse)
    if not self.locking then
        self.mouse = current_mouse
        return
    end

    local previous_mouse = self.mouse
    if previous_mouse then
        local ok, err = set_mouse_lock(previous_mouse, false)
        if not ok then
            write_log("set_lock_mouse(false) failed: " .. tostring(err))
        end
    end

    if current_mouse and current_mouse ~= previous_mouse then
        local ok, err = set_mouse_lock(current_mouse, false)
        if not ok then
            write_log("set_lock_mouse(false) failed: " .. tostring(err))
        end
    end

    self.locking = false
    self.mouse = current_mouse
end

local function update_lock(self)
    if self.disabled then
        return
    end

    local mouse = get_mouse()
    if not mouse then
        if not self.initialized then
            self.unavailable = (self.unavailable or 0) + 1
            if self.unavailable > 30 then -- ~0.5s grace for early-frame nil
                write_log("mouse unavailable; disabling")
                self.disabled = true
            end
        end
        return
    end
    self.unavailable = 0

    if type(mouse.set_lock_mouse) ~= "function" then
        write_log("Input mouse has no set_lock_mouse(); disabling")
        self.disabled = true
        return
    end

    self.initialized = true

    if self.locking and self.mouse and self.mouse ~= mouse then
        local ok, err = set_mouse_lock(self.mouse, false)
        if not ok then
            write_log("set_lock_mouse(false) failed: " .. tostring(err))
        end
        self.locking = false
    end

    local should_lock = frame_is_active() and player_is_active() and not menu_is_open()
    if not should_lock then
        release_lock(self, mouse)
        return
    end

    if not self.locking and type(mouse.acquire) == "function" then
        local ok, err = call_method(mouse, "acquire")
        if not ok then
            write_log("mouse acquire failed: " .. tostring(err))
        end
    end

    local ok, err = set_mouse_lock(mouse, true)
    if not ok then
        write_log("set_lock_mouse(true) failed; disabling: " .. tostring(err))
        self.disabled = true
        release_lock(self, mouse)
        return
    end

    self.locking = true
    self.mouse = mouse
end

local ok, err = pcall(update_lock, state)
if not ok then
    write_log("runtime error; disabling: " .. tostring(err))
    state.disabled = true
end
