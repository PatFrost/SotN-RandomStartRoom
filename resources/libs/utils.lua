-- Written by Frost


UTILS = {}


package.loaded["winapi"] = nil
pcall(function() require("winapi") end)

JSON = require("./resources/libs/JSON")


local PY_EXT = '.exe'
if string.find(string.upper(os.getenv('PATH')), 'PYTHON') then
    PY_EXT = '.py' -- Has Python
end
local PY_EXE = {'.', 'resources', 'libs', 'python', 'RandomStartRoom'..PY_EXT}


function UTILS.setIconHandle()
    if winapi then
        winapi.shell_exec(nil, table.concat(PY_EXE, '\\'), 'icon=true', nil, winapi.SW_HIDE)
    -- else
        -- local cut = assert(io.popen(table.concat(PY_EXE, '/')..'icon=true', 'r'))
        -- local output = assert(cut:read('*a'))
        -- cut:close()
    end
end

function UTILS.unCut()
    local output = ""
    if winapi then
        proc, file = winapi.spawn_process('cmd /c ' .. table.concat(PY_EXE, '\\'))
        output = file:read()
        proc:wait()
        file:close()
    -- else
        -- local cut = assert(io.popen(table.concat(PY_EXE, '/'), 'r'))
        -- output = assert(cut:read('*a'))
        -- cut:close()
    end

    return bizstring.trim(output)
end

local soundon, ispaused
function UTILS.pause()
    soundon = client.GetSoundOn()
    ispaused = client.ispaused()
    if soundon then
        client.SetSoundOn(false)
    end
    client.pause()
end
function UTILS.unpause()
    if ispaused == false then
        client.unpause()
    end
    if soundon == true then
        client.SetSoundOn(true)
    end
    soundon = nil -- client.GetSoundOn()
    ispaused = nil -- client.ispaused()
end

local msgid
function UTILS.destroymsgid()
    if msgid and winapi then
        local wid = winapi.find_window(nil, msgid)
        if wid:get_text() == msgid then
            wid:destroy()
            UTILS.unpause()
            msgid = nil
        end
    end
end
function UTILS.message(title, msg, btn, icon)
    -- btns: (default "ok") one of "ok", "ok-cancel", "yes", "yes-no", "abort-retry-ignore", "retry-cancel", "yes-no-cancel"
    -- icon: (default "information") one of "information", "question", "warning", "error"
    icon = icon or 'information'
    if msgid and winapi then
        UTILS.destroymsgid()
    elseif not msgid and winapi then
        msgid = title..' '
        UTILS.pause()
        winapi.show_message(msgid, msg, btn or 'ok', icon)
        UTILS.unpause()
        msgid = nil
    else
        print('')
        print('***'..icon..'***')
        print(title)
        print(msg)
        print('')
    end
end

function UTILS.showHawk()
    if winapi then
        -- local hawk = winapi.find_window(nil, gameinfo.getromname()..' [PlayStation] - BizHawk')
        local hawk = winapi.find_window_match('- BizHawk')
        hawk:show()
        hawk:set_foreground()
    end
end

function UTILS.centerWindow(window)
    if winapi then
        -- Windows
        local w, h = winapi.get_desktop_window():get_bounds()
        local wid = winapi.find_window(nil, UTILS.TITLE)
        local w2, h2 = wid:get_bounds()
        -- print((w/2.0)-(w2/2.0), (h/2.0)-(h2/2.0))
        -- forms.setlocation(window.bg, (w/2.0)-(w2/2.0)-81, (h/2.0)-(h2/2.0)-35) -- not work correctly
        wid:resize((w/2.0)-(w2/2.0), (h/2.0)-(h2/2.0), w2, h2)
        -- wid:send_message(0x0080, 0, hIcon) -- not work
        -- print(wid:get_module_filename())
    else
        -- Others Platform
        forms.setlocation(window.bg, UTILS.settings.coords.x, UTILS.settings.coords.y)
    end
    UTILS.setIconHandle()
end


function UTILS.shuffle(array)
    local mixed = {}
    local rand = math.random

    for index=1, #array do
        local offset = index - 1
        -- local value = array[index]
        local iRandom = offset*rand()
        local iFloored = iRandom - iRandom%1

        if iFloored == offset then
            mixed[#mixed + 1] = array[index]
        else
            mixed[#mixed + 1] = mixed[iFloored + 1]
            mixed[iFloored + 1] = array[index]
        end
    end

    return mixed
end

local random_time = os.time()
-- be sure to set randomseed somewhere for better randomness and wait 1 sec before call random
math.randomseed(random_time)

function UTILS.setRandom()
    if os.time() - random_time < 1 then
        client.exactsleep(1000)
    end
    math.random()
end

function UTILS.random(from, to, exclude)
    if exclude then
        local exc = '_'..table.concat(exclude, '_')..'_'
        local tbl = {}
        for i in UTILS.range(from, to) do
            if not exc:find('_'..i..'_') then
                table.insert(tbl, i)
            end
        end
        return tbl[math.random(#tbl)]
    else
        return math.random(from, to)
    end
end

-- http://lua-users.org/wiki/RangeIterator
function UTILS.range(from, to, step)
    step = step or 1
    return function(_, lastvalue)
        local nextvalue = lastvalue + step
        if step > 0 and nextvalue <= to or step < 0 and nextvalue >= to or step == 0 then
            return nextvalue
        end
    end, nil, from - step
end


function UTILS.timeTook(st)
    local t = os.clock() - st
    local h = math.floor(t / 3600)
    t = t - (h * 3600)
    local m = math.floor(t / 60)
    t = t - (m * 60)
    local s = t -- math.floor(t / 1)

    local took = ''
    if h > 0 then took = took .. h .. ':' end
    -- if m > 0 then took = took .. m .. ':' end
    if m > 0 then took = took .. string.format("%02d", m) .. ':' end
    return took .. string.format("%06.3f", s)
    -- return took .. string.format("%.3f", s)
end


function UTILS.loadSettings()
    local d = io.open("resources/default_settings.json", "r")
    local default = d:read("*all")
    d:close()
    local saved
    local f = io.open("settings.json", "r")
    if f then
        saved = f:read("*all")
        f:close()
    end
    default = JSON:decode(default)
    if saved then
        saved = JSON:decode(saved)
        for key, i in pairs(saved) do
            if key ~= "version" then
                default[key] = saved[key]
            end
        end
    else
        UTILS.saveSettings(default)
    end
    return default
end

function UTILS.saveSettings(settings)
    local f = io.open("settings.json", "w")
    if f then
        f:write(JSON:encode_pretty(settings))
        f:close()
    end
end

UTILS.settings = UTILS.loadSettings()
return UTILS
