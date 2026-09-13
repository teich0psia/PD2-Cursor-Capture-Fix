if rawget(_G, "PD2CCF_MenuInitialized") then
    return
end
_G.PD2CCF_MenuInitialized = true

local MOD_PATH = ModPath
local SETTINGS_PATH = (SavePath or "mods/saves/") .. "PD2-Cursor-Capture-Fix.json"

local settings = rawget(_G, "PD2CCF_Settings")
if not settings then
    settings = {
        high_polling_rate = false
    }
    _G.PD2CCF_Settings = settings
end

if not rawget(_G, "PD2CCF_SettingsLoaded") then
    if io.file_is_readable and io.file_is_readable(SETTINGS_PATH) and io.load_as_json then
        local ok, data = pcall(io.load_as_json, SETTINGS_PATH)
        if ok and type(data) == "table" and type(data.high_polling_rate) == "boolean" then
            settings.high_polling_rate = data.high_polling_rate
        end
    end
    _G.PD2CCF_SettingsLoaded = true
end

local function save_settings()
    if io.save_as_json then
        io.save_as_json(settings, SETTINGS_PATH)
        return
    end

    local file = io.open(SETTINGS_PATH, "w+")
    if file then
        file:write(json.encode(settings))
        file:close()
    end
end

Hooks:Add("LocalizationManagerPostInit", "PD2CCF.Localization", function(localization_manager)
    localization_manager:load_localization_file(MOD_PATH .. "loc/en.txt", false)

    local ok, language_key = pcall(function()
        return SystemInfo:language():key()
    end)
    if ok and language_key == Idstring("japanese"):key() then
        localization_manager:load_localization_file(MOD_PATH .. "loc/ja.txt", true)
    end
end)

Hooks:Add("MenuManagerInitialize", "PD2CCF.Menu", function()
    MenuCallbackHandler.PD2CCF_ToggleHighPolling = function(_, item)
        settings.high_polling_rate = item:value() == "on"
        save_settings()
    end

    MenuHelper:LoadFromJsonFile(MOD_PATH .. "menu/options.json", nil, settings)
end)
