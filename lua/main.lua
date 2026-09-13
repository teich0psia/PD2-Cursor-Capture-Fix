if rawget(_G, "PD2CCF_EngineLock_PersistStop") then
    return
end

local function write_log(message)
    if type(_G.log) == "function" then
        _G.log("[PD2CCF] " .. tostring(message))
    end
end

local state = rawget(_G, "PD2CCF_EngineLock_State")

if not state then
    state = {
        initialized = false,
        locking = false
    }
    _G.PD2CCF_EngineLock_State = state
end

local function get_mouse()
    if not Input or type(Input.mouse) ~= "function" then
        return nil
    end

    local ok, mouse = pcall(function()
        return Input:mouse()
    end)

    if not ok then
        return nil
    end

    return mouse
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

local function call_mouse_method(mouse, method_name, ...)
    local method = mouse and mouse[method_name]
    if type(method) ~= "function" then
        return false, "missing method: " .. method_name
    end

    return pcall(method, mouse, ...)
end

local function update(self)
    local mouse = get_mouse()
    if not mouse then
        if not self.initialized then
            write_log("Input:mouse() unavailable; disabling")
            _G.PD2CCF_EngineLock_PersistStop = true
        end
        return
    end

    if not self.initialized then
        if type(mouse.set_lock_mouse) ~= "function" then
            write_log("Input mouse has no set_lock_mouse(); disabling")
            _G.PD2CCF_EngineLock_PersistStop = true
            return
        end

        self.initialized = true
    end

    local focused = frame_is_active()
    local should_lock = focused and player_is_active() and not menu_is_open()

    if should_lock then
        if not self.locking and type(mouse.acquire) == "function" then
            local acquire_ok, acquire_err = call_mouse_method(mouse, "acquire")
            if not acquire_ok then
                write_log("mouse acquire failed: " .. tostring(acquire_err))
            end
        end

        local ok, err = call_mouse_method(mouse, "set_lock_mouse", true)
        if not ok then
            write_log("set_lock_mouse(true) failed; disabling: " .. tostring(err))
            _G.PD2CCF_EngineLock_PersistStop = true
            return
        end

        self.locking = true
    elseif self.locking then
        local ok, err = call_mouse_method(mouse, "set_lock_mouse", false)
        if not ok then
            write_log("set_lock_mouse(false) failed: " .. tostring(err))
        end
        self.locking = false
    end
end

local ok, err = pcall(update, state)
if not ok then
    write_log("runtime error; disabling: " .. tostring(err))
    _G.PD2CCF_EngineLock_PersistStop = true
end
