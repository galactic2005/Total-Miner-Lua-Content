local settings_screen = {
    debugMode = false,

    header = "Physics Test World Settings",
    experimentalText = "Warning!\n\nThis setting is an experimental feature. It may break and either be implemented or removed in the future. Please provide any feedback if you choose to use this. Thank you!",

    -- setting options
    {
        settingText = "- Notifications -",
        forceRestartSettings = true
    },
    {
        -- Disable All Notifications
        --
        -- Disables all notifications
        history = "settings\\disablegamenotifications",
        settingText = "Disable All Notifications",

        descriptionText = "Disables all notifications from anywhere in the game."
    },
    {
        -- Skip Intro Join Notifications
        --
        -- Skips the Intro notifications that appear upon Joining
        history = "settings\\skipintronotifications",
        settingText = "Skip Intro Join Notifications",

        descriptionText = "Disables the intro notifications that are shown upon joining.",

        showCondition = {
            type = "historyIsDisabled",
            history = "settings\\disablegamenotifications"
        }
    },

    {
        settingText = "- Auto-Equip -",
        forceRestartSettings = true
    },
    {
        -- Disable Auto-Equipping of Items
        --
        -- Disables Auto-Equipping of Items given by Item Givers
        history = "settings\\autoequipdisable",
        settingText = "Disable Auto-Equipping of Items",

        descriptionText = "Disables Auto-Equipping of items given by Item Givers."
    },
    {
        -- Auto-Equip Holdable Items to Left Hand
        --
        -- Items are automatically equipped to the preferred hand
        history = "settings\\autoequiplefthand",
        settingText = "Auto-Equip Holdable Items to Left Hand",

        descriptionText = "Auto-Equipping equips items in the left hand instead of the right.",

        showCondition = {
            type = "historyIsDisabled",
            history = "settings\\autoequipdisable"
        }
    },

    {
        settingText = "- Misc. -",
        forcePageBreak = true,
        forceRestartSettings = true
    },
    {
        -- Instant Fail Teleport
        --
        -- Failed parkours instantly teleport you instead of using a transition
        history = "settings\\instantfailteleport",
        settingText = "Instant Fail Teleport",

        descriptionText = "Upon failing a parkour, the teleport is instant instead of using a transition."
    },
    {
        -- Instant Win Teleport
        --
        -- Won parkours instantly teleport you instead of using a transition
        history = "settings\\instantwinteleport",
        settingText = "Instant Win Teleport",

        descriptionText = "Upon winning a parkour, the teleport is instant instead of using a transition."
    },
    {
        -- Faster Teleport Transitions
        --
        -- Transitions are double the speed compared to normal
        history = "settings\\fasterteleport",
        settingText = "Faster Teleport Transitions",

        descriptionText = "Any transition is double the speed compared to normal.",

        showCondition = {
            type = "nand",
            {
                type = "historyIsDisabled",
                history = "settings\\instantfailteleport"
            },
            {
                type = "historyIsDisabled",
                history = "settings\\instantwinteleport"
            }
        }
    },

    {
        settingText = "- Experimental -",
        forcePageBreak = true,
        forceRestartSettings = true
    },
    {
        -- Death Teleport
        --
        -- Dying in a section instantly teleports you back instead of starting at the main hub
        history = "settings\\deathteleport",
        settingText = "Death Teleport (Experimental)",

        descriptionText = "Upon death, you'll be teleported back to where you were instead of the Main Hub.",

        experimentalWarning = true
    }
}

local debug_mode = settings_screen.debugMode

local function debug_mode_message(message)
    if debug_mode then print(message) end
end

-- functions for conditionals
local conditonal_handler = {
    ["historyisdisabled"] = function(parameters)
        -- true if the given history is set to 0
        return get_history(parameters.history) == 0
    end,

    ["historyisenabled"] = function(parameters)
        -- true if the given history is set to 1
        return get_history(parameters.history) == 1
    end,

    ["historyissettovalue"] = function(parameters)
        -- true if the given history is set to the value defined
        return get_history(parameters.history) == parameters.value
    end
}

-- functions for conditional tables
local conditonal_tables_handler = {
    ["and"] = function(parameters)
        -- true if all parameters are true
        for i = 1, #parameters, 1 do
            parameters[i].type = (parameters[i].type and parameters[i].type) or "historyIsDisabled"
            if not conditonal_handler[parameters[i].type:lower()](parameters[i]) then
                return false
            end
        end
        return true
    end,

    ["xand"] = function(parameters)
        -- true if all parameters are false
        for i = 1, #parameters, 1 do
            parameters[i].type = (parameters[i].type and parameters[i].type) or "historyIsDisabled"
            if conditonal_handler[parameters[i].type:lower()](parameters[i]) then
                return false
            end
        end
        return true
    end,

    ["nand"] = function(parameters)
        -- true if all parameters are not true
        for i = 1, #parameters, 1 do
            parameters[i].type = (parameters[i].type and parameters[i].type) or "historyIsDisabled"
            if conditonal_handler[parameters[i].type:lower()](parameters[i]) then
                return true
            end
        end
        return false
    end,

    ["or"] = function(parameters)
        -- true if any parameter is true
        for i = 1, #parameters, 1 do
            parameters[i].type = (parameters[i].type and parameters[i].type) or "historyIsDisabled"
            if conditonal_handler[parameters[i].type:lower()](parameters[i]) then
                return true
            end
        end
        return false
    end,

    ["xor"] = function(parameters)
        -- true if any parameter is false
        for i = 1, #parameters, 1 do
            parameters[i].type = (parameters[i].type and parameters[i].type) or "historyIsDisabled"
            if conditonal_handler[parameters[i].type:lower()](parameters[i]) then
                return false
            end
        end
        return true
    end
}

local function is_condition_accepted(parameters)
    if type(parameters[1]) == "table" then
        -- failsafe type, default to "and"
        parameters.type = (parameters.type and parameters.type) or "and"

        return conditonal_tables_handler[parameters.type:lower()](parameters)
    else
        -- failsafe type, default to "historyIsDisabled"
        parameters.type = (parameters.type and parameters.type) or "historyIsDisabled"

        return conditonal_handler[parameters.type:lower()](parameters)
    end
end

local shown_settings_body = { }
local shown_settings_utility = { }

local current_setting_object = { }

local setting_condition = { }
local setting_history = 0
local setting_text = ""

local add_setting = true

local page_limit = 9
local setting_pages = math.floor(#settings_screen / page_limit) + 1

debug_mode_message("Pages: " .. setting_pages)

local current_page = 0
local current_i_page = 1

for i = 1, #settings_screen, 1 do
    current_setting_object = settings_screen[i]

    if math.floor(current_i_page - (current_page * page_limit)) == 1 or current_setting_object.forcePageBreak == true then
        -- start a new page
        current_page = current_page + 1
        current_i_page = 0

        debug_mode_message("New page started, on page " .. current_page)
    end
    current_i_page = current_i_page + 1

    if current_setting_object.settingText == nil then
        -- failsafe text in case the settingText was not set
        current_setting_object.settingText = "Setting Text not found"
    end

    if current_setting_object.history ~= nil then
        -- change setting text based on history
        setting_history = get_history(current_setting_object.history)
        setting_text = ((setting_history == nil or setting_history == 0) and tostring(current_setting_object.settingText .. " - Disabled")) or tostring(current_setting_object.settingText .. " - Enabled")
    else
        setting_text = tostring(current_setting_object.settingText)
    end

    add_setting = true

    setting_condition = current_setting_object.showCondition
    if setting_condition ~= nil then
        -- conditional setting, only appears if another parameter is set
        add_setting = is_condition_accepted(setting_condition)
    end

    if add_setting then
        if shown_settings_body[current_page] == nil then
            -- make sure the current page actually exists before trying to index with it
            shown_settings_body[current_page] = { }
            shown_settings_utility[current_page] = { }
        end

        -- add setting to settings screen
        shown_settings_body[current_page][#shown_settings_body[current_page]+1] = setting_text
        shown_settings_utility[current_page][#shown_settings_utility[current_page]+1] = current_setting_object
    end
end

current_page = get_history("settings\\utility\\currentpage")
if current_page < 1 or current_page > #shown_settings_body then
    -- failsafe in case the page count is out of bounds, often used the first time a player uses this
    set_history("settings\\utility\\currentpage", 1)
    current_page = 1
end

-- wether we allow the page switch button to appear or not
local switch_page_button = #shown_settings_body > 1

debug_mode_message("Current page: " .. current_page .. " with options up to " .. #shown_settings_body[current_page])

local selected_option = menu(
    settings_screen.header,
    shown_settings_body[current_page],
    {
        -- if there isn't any pages past the first one, do not show the next page button
        (switch_page_button and "Next Page") or "Exit Settings",
        (switch_page_button and "Exit Settings") or nil
    }
)

if selected_option < 1 or selected_option > #shown_settings_body[current_page] then
    if switch_page_button and selected_option == #shown_settings_body[current_page] + 1 then
        -- go to next page of settings

        current_page = current_page + 1

        set_history("settings\\utility\\currentpage", current_page)
        debug_mode_message("Selected next page, now at page " .. current_page)

        script("SettingsMenu\\Main_lua")
        return
    end

    -- exit settings

    debug_mode_message("Exited settings...")
    set_history("settings\\utility\\currentpage", 1)
    return
end

if shown_settings_utility[current_page][selected_option].forceRestartSettings == true or shown_settings_utility[current_page][selected_option].history == nil then
    -- restart settings if forceRestartSettings is true or the history is nil

    debug_mode_message("Restarted settings from option " .. selected_option)
    script("SettingsMenu\\Main_lua")
    return
end

current_setting_object = shown_settings_utility[current_page][selected_option]

local is_setting_enabled = get_history(current_setting_object.history) == 1

local is_setting_enabled_text = (is_setting_enabled and " - Enabled\n\n") or " - Disabled\n\n"
local is_setting_experimental_text = (current_setting_object.experimentalWarning ~= nil and settings_screen.experimentalText .. "\n\n") or ""

-- create our large header textbox
local header_text = tostring(current_setting_object.settingText ..
is_setting_enabled_text ..
is_setting_experimental_text ..
current_setting_object.descriptionText)

local confirmation_option = menu(
    header_text,
    (is_setting_enabled and "Disable Setting") or "Enable Setting",
    "Cancel"
)

if confirmation_option ~= 1 then
    -- restart settings if "Cancel" is selected

    script("SettingsMenu\\Main_lua")
    return
end

-- toggle history
set_history(current_setting_object.history, (is_setting_enabled and 0) or 1)

-- notification for setting change
if get_history("settings\\disablegamenotifications") == 0 then
   notify("Player setting changed.")
end

-- restart settings due to reaching end of setting script
script("SettingsMenu\\Main_lua")