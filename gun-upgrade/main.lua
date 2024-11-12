Config = {
    Map = nil,
    Items = {

    }
}

function Client.OnStart()
    _DEBUG = true
    _HASH = "01ca769"
    _LATEST_LINK = "https://raw.githubusercontent.com/cubzh/cubzh-minigames/" .. _HASH .. "/gun-upgrade/"
    _LOADALL()
end

_LOAD_LIST = {
    modules = {
        game = "modules/game.lua",
    },
    images = {
        -- images
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
    log("Need to download " .. tableLength(_LOAD_LIST.modules) .. " modules files.")
    for k, v in pairs(_LOAD_LIST.modules) do
        local downloaded = 0
    
        for k, v in pairs(_LOAD_LIST.modules) do
            HTTP:Get(_LATEST_LINK .. v, function(response)
                if response.StatusCode ~= 200 then
                    print("Error downloading [" .. k .. ".lua]. Code: " .. response.StatusCode)
    
                    return
                end
    
                _ENV[k] = load(response.Body:ToString(), nil, "bt", _ENV)()
                log("Module [".. k.. ".lua] downloaded.")
    
                downloaded = downloaded + 1
                if downloaded == tableLength(_LOAD_LIST.modules) then
                    log("Downloaded all required modules.")
                    _INIT_MODULES()
                end
            end)
        end
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

    log("Module initialization completed.")
    _FINISH()
end

function log(text, type)
    if _LOGS == nil then _LOGS = {} end
    if type == nil then
        type = "DEFAULT"
    end
    local timeStamp = os.date("[%H:%M:%S]")
    local log_text = timeStamp .. " " .. "EMPTY LOG."
    if type == "DEFAULT" then
        log_text = timeStamp .. " " .. "[INFO]: " .. text
    elseif type == "INIT" then
        log_text = timeStamp .. " " .. "[INIT] Module [" .. text .. ".lua] initialized."
    elseif type == "ERROR" then
        log_text = timeStamp .. " " .. "[ERROR]: ".. text
    elseif type == "WARNING" then
        log_text = timeStamp .. " " .. "[WARNING]: " .. text
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