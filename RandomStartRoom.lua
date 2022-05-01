-- Written by Frost


console.clear()

package.loaded["./resources/libs/sotn"] = nil
SOTN = require("./resources/libs/sotn")


local TITLE = "SotN-RandomStartRoom - v" .. UTILS.settings.version
UTILS.TITLE = TITLE

HAS_ROM_HASH = gameinfo.getromhash() ~= ""
if not HAS_ROM_HASH then
    UTILS.message(TITLE, 'Start Castlevania - SotN first!', 'ok', 'warning')
elseif mainmemory.readbyte(0x03C734) == 2 then
    UTILS.message(TITLE, 'Stop your game first!', 'ok', 'warning')
    HAS_ROM_HASH = false
end


UTILS.pause()

local room = ROOMS.getRoom()
local iColor = tonumber
local dialog = {}
-- print(JSON:encode_pretty(room))
-- print(JSON:encode_pretty(UTILS.settings))


local function setMap(reset)
    local w = room.map.w or 15
    local h = room.map.h or 15
    local x = w * (room.map.x+2)
    local y = h * room.map.y
    local scale = 1.25
    local size = 11/scale
    x = (x - scale)/scale
    y = (y - scale)/scale

    if reset and dialog.group then
        forms.clear(dialog.group, iColor(UTILS.settings.color.Clear))
    end
    dialog.group = forms.pictureBox(dialog.bg, 0, 20, 986/scale, 731/scale)
    forms.drawRectangle(dialog.group, 0, 0, 986/scale, 731/scale, iColor(UTILS.settings.color.Black), iColor(UTILS.settings.color.Black))
    local image
    if room.vs == 0x38 then
        image = UTILS.settings.images.rvsd
    elseif room.vs == 0x18 then
        image = UTILS.settings.images.rvsr
    elseif not room.map.inv then
        image = UTILS.settings.images.map1
    elseif room.map.inv == 2 then
        image = UTILS.settings.images.map2
    elseif room.map.inv == 3 then
        image = UTILS.settings.images.map3
    end
    if image then
        forms.drawImage(dialog.group, image, size, size, 964/scale, 709/scale, true)
    end

    if not room.vs then
        forms.drawEllipse(forms.pictureBox(dialog.group, x, y, size, size),
            x, y, size, size, iColor(UTILS.settings.color.Black), iColor(UTILS.settings.pointer.color))
    end

    forms.settext(dialog.descList, string.format("%d. %s", room.pos+1, room.desc))
    forms.refresh(dialog.group)
end

local eventtime = os.clock()
local function eventLists()
    local selected = forms.gettext(dialog.colorList)
    if UTILS.settings.color[selected] ~= UTILS.settings.pointer.color then
        UTILS.settings.pointer.color = UTILS.settings.color[selected]
        setMap()
    end

    if os.clock() - eventtime > 0.5 then
        selected = forms.gettext(dialog.descList)
        if ROOMS.rooms[ROOMS.descToIndex[selected]] ~= room then
            room = ROOMS.rooms[ROOMS.descToIndex[selected]]
            setMap()
        end
        eventtime = os.clock()
    end
end

local function showDialog()
    forms.destroyall()
    dialog.bg = forms.newform(UTILS.settings.coords.w, UTILS.settings.coords.h,
        TITLE, function(x) dialog.cancel=true end)
    UTILS.centerWindow(dialog.bg)

    dialog.descList = forms.dropdown(dialog.bg, {room.desc}, 0, 0, 590, 794)
    forms.setdropdownitems(dialog.descList, ROOMS.droplist, false)
    -- forms.addclick(dialog.descList, function(x) eventLists() end)

    local space = 30
    local posx, posy = 626, 20
    forms.button(dialog.bg, "RANDOM ROOM", function(x)
        room = ROOMS.getRoom()
        setMap(true)
    end, posx, posy, 145, 25)
    forms.button(dialog.bg, "RICHTER VS. DRACULA", function(x)
        room = ROOMS.getRoom(0x38)
        room.vs = 0x38
        setMap(true)
    end, posx, posy+space, 145, 25)
    forms.button(dialog.bg, "RICHTER VS. RICHTER", function(x)
        room = ROOMS.getRoom(0x18)
        room.vs = 0x18
        setMap(true)
    end, posx, posy+(space*2), 145, 25)
    forms.button(dialog.bg, "OK", function(x)
        if mainmemory.readbyte(0x03C734) == 8 then
            dialog.okClicked = true
            forms.destroy(dialog.bg)
        else
            UTILS.message(TITLE, forms.gettext(dialog.statusLBL))
        end
    end, posx, posy+(space*3), 145, 25)

    -- Info game
    posx, posy = 596, 145
    forms.label(dialog.bg, "GAME", posx+87, posy, 64, 15)
    forms.pictureBox(dialog.bg, posx, posy+15, 270, 1) -- used as seperator
    forms.label(dialog.bg, gameinfo.getromname(), posx, posy+20, 200, 15)
    forms.label(dialog.bg, "Hash: "..gameinfo.getromhash(), posx, posy+35, 200, 15)
    forms.label(dialog.bg, "Seed :\nPreset :\nVersion :", posx, posy+48, 45, 45)
    dialog.gInfo = forms.label(dialog.bg, SOTN.getSeed(), posx+42, posy+48, 155, 45)

    -- Info status
    posy = 240
    forms.label(dialog.bg, "STATUS", posx+80.5, posy, 64, 15)
    forms.pictureBox(dialog.bg, posx, posy+15, 270, 1) -- used as seperator
    dialog.statusLBL = forms.label(dialog.bg, "Busy", posx, posy+20, 200, 155)

    -- Options
    posy = 415
    forms.label(dialog.bg, "OPTIONS", posx+79, posy, 64, 15)
    forms.pictureBox(dialog.bg, posx, posy+15, 270, 1) -- used as seperator

    forms.label(dialog.bg, "Room color:", posx, posy+29, 64, 15)
    local list = {}
    for name, i in pairs(UTILS.settings.color) do table.insert(list, name) end
    dialog.colorList = forms.dropdown(dialog.bg, list, posx+65, posy+25, 135, 100)
    forms.settext(dialog.colorList , "Green")

    forms.pictureBox(dialog.bg, posx, 470, 270, 1) -- used as seperator
    forms.label(dialog.bg, "Powered by Frost", 716, 475, 100, 15)

    setMap()
end

local oldstatus
local function setStatusLabel()
    if dialog.statusLBL then
        local st = mainmemory.readbyte(0x03C734)
        if st ~= oldstatus then
            -- print("new status: "..st)
            oldstatus = st
            local text = "Busy"
            if st == 1 then
                text = 'On game "Press Start Button",\nGo to in "File Select".\nAnd on this window press "OK" button.'
            elseif st == 8 then
                text = 'Press "OK" button, wait 3 secondes and Start New Game.'
            end

            if st == 1 or st == 8 then
                cut1, cut2 = SOTN.getCutScene()
                if cut1 and cut1 ~= 26 then
                    text = text .. '\n\nRemenber,\nYour game version is not fully compatible with this tool. Use original game or use this code "800A2988 001A" by default this tool enable this code, but make sure this code enabled all times with this tool.'
                end
            end
            forms.settext(dialog.statusLBL, text)
            forms.refresh(dialog.statusLBL)
        end
    end
end


local addEquip = true
local cheatAdded = 0
local stime = 0 -- time start entering In Select your Destiny or In File Select
local sleep = 3 -- time to sleep in secs before activate cheat
function checkStartGame()
    local status = mainmemory.readbyte(0x03C734)
    if addEquip and status == 4 then
        SOTN.setEquip(room)
    elseif status == 2 then
        -- In Game
        if cheatAdded == 1 then
            client.removecheat('D00974A0 00' .. bizstring.hex(room.pos))
            client.removecheat('8003C9A0 0001') -- desable richter
            cheatAdded = 2
        end
    elseif status == 8 then
        -- In Select your Destiny or In File Select
        if stime == 0 then
            stime = os.time() + sleep
        end
        if cheatAdded == 0 and os.time() > stime then
            client.removecheat('8003C9A0 0001') -- desable richter
            if room.vs == 0x18 or room.vs == 0x38 then
                client.addcheat('8003C9A0 0001') -- enable richter
                print("Cheat: Force play as Richter")
            end
            client.addcheat('8003CAFC 0000') -- Stereo On
            print("Cheat: Stereo On")
            client.addcheat('D00974A0 00' .. bizstring.hex(room.pos)) -- set start room
            cut1, cut2 = SOTN.getCutScene()
            if cut1 and cut1 ~= 26 then
                client.addcheat('800A2988 001A') -- Remove Maria cut scene patched by SotN-Randomizer
                print("Cheat: Maria uncut scene")
            end
            cheatAdded = 1
        end
    end
end

event.onexit(function(x)
    UTILS.saveSettings(UTILS.settings)
    forms.destroyall()
    UTILS.destroymsgid()
    UTILS.unpause()
    client.removecheat('D00974A0 0000')
    client.removecheat('8003C9A0 0001') -- desable richter
end)

if not HAS_ROM_HASH or mainmemory.readbyte(0x03C734) ~= 2 then
    client.removecheat('800A2988 001A')
    client.removecheat('D00974A0 0000')
    client.removecheat('8003C9A0 0001') -- desable richter
    client.removecheat('8003CAFC 0000') -- Stereo On
    client.removecheat('8003C4E6 BCAA') -- Save Palette
end

if HAS_ROM_HASH then
    UTILS.showHawk()
    showDialog()
end

UTILS.unpause()

local hasinfo
while HAS_ROM_HASH do
    if dialog.okClicked or dialog.cancel then
        break -- End of script
    else
        if not hasinfo then
            local gi = forms.gettext(dialog.gInfo)
            if not gi or gi == "" then
                forms.settext(dialog.gInfo, SOTN.getSeed())
            else
                hasinfo = true
            end
        end
        setStatusLabel()
        eventLists()
    end
    emu.yield()
end

if dialog.okClicked then
    addEquip = room.pos ~= 0x1F and room.pos ~= 0X3F and room.pos ~= 0x41
    while true do
        if cheatAdded == 2 then
            if addEquip then
                SOTN.setupGame(room)
            end
            print(JSON:encode_pretty(room))
            break -- End of script
        end
        checkStartGame()
        emu.frameadvance()
    end
end
