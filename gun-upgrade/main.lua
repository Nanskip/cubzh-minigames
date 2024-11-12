-- GUN UPGRADE GAME --

Config = {
    Map = nil,
    Items = {

    }
}

function Client.OnStart()
    _DEBUG = true
    _HASH = "0bfaf7e"
    _LATEST_LINK = "https://raw.githubusercontent.com/Nanskip/cubzh-minigames/" .. _HASH .. "/gun-upgrade/"
    _LOADALL()
end

_LOAD_LIST = {
    modules = {
        game = "modules/game.lua",
    },
    images = {
        icon = "images/icon.jpg",
    },
    sounds = {
        -- sounds
    },
    other = {
        -- other
    }
}

function _LOADALL()
    log("Starting up...")
    _LOAD_MODULES()
end

function _FINISH()
    log("Downloading finished.")
end

function _LOAD_MODULES()
    log("Need to download " .. tableLength(_LOAD_LIST.modules) .. " module files.")
    for k, v in pairs(_LOAD_LIST.modules) do
        local downloaded = 0
    
        HTTP:Get(_LATEST_LINK .. v, function(response)
            if response.StatusCode ~= 200 then
                log("Error downloading [" .. k .. ".lua]. Code: " .. response.StatusCode, "ERROR")

                return
            end

            _ENV[k] = load(response.Body:ToString(), nil, "bt", _ENV)()
            log("Module [".. k.. ".lua] downloaded.")

            downloaded = downloaded + 1
            if downloaded == tableLength(_LOAD_LIST.modules) then
                log("Downloaded all required module files.")
                _INIT_MODULES()
            end
        end)
    end
end

function _INIT_MODULES()
    log("Initializing modules...")
    for k, v in pairs(_LOAD_LIST.modules) do
        if _ENV[k].INIT ~= nil then
            local initialized = _ENV[k]:INIT()
            if initialized then
                log(k, "INIT")
            else
                log("Module [" .. k .. ".lua] initialization error.", "ERROR")
            end
        else
            log("Module [" .. k .. ".lua] has no initialization function.", "WARNING")
        end
    end

    log("All modules have been initialized.")
    _LOAD_IMAGES()
end

function _LOAD_IMAGES()
    log("Need to download " .. tableLength(_LOAD_LIST.images) .. " IMAGE files.")
    _IMAGES = {}
    for k, v in pairs(_LOAD_LIST.images) do
        local downloaded = 0

        HTTP:Get(_LATEST_LINK .. v, function(response)
            if response.StatusCode ~= 200 then
                log("Error downloading [" .. k .. "] image. Code: " .. response.StatusCode, "ERROR")

                return
            end

            _IMAGES[k] = response.Body
            log("Image [".. k.. "] downloaded.")

            downloaded = downloaded + 1
            if downloaded == tableLength(_LOAD_LIST.images) then
                log("Downloaded all required image files.")
                _FINISH()
            end
        end)
    end
end

function log(text, type)
    if _LOGS == nil then _LOGS = {} end
    if type == nil then
        type = "INFO"
    end
    local timeStamp = os.date("[%H:%M:%S]")
    local log_text = timeStamp .. " " .. "EMPTY LOG."
    if type == "INFO" then
        log_text = timeStamp .. " " .. "[INFO]: " .. text
    elseif type == "INIT" then
        log_text = timeStamp .. " " .. "[INIT]: Module [" .. text .. ".lua] initialized."
    elseif type == "ERROR" then
        log_text = timeStamp .. " " .. "[ERROR]: ".. text
    elseif type == "WARNING" or type == "WARN" then
        log_text = timeStamp .. " " .. "[WARN]: " .. text
    end

    _LOGS[#_LOGS+1] = log_text
    if _DEBUG == true then
        print(log_text)
    end
end

function tableLength(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end