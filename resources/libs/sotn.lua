-- Written by Frost


SOTN = {}


package.loaded["./resources/libs/rooms"] = nil
ROOMS = require("./resources/libs/rooms")


local hand_start, hand_end     = 0x09798A, 0x097A32
local body_start, body_end     = 0x097A33, 0x097A4C
local alucart_mail             = 0x097A8C
local head_start, head_end     = 0x097A4D, 0x097A62
local cloak_start, cloak_end   = 0x097A63, 0x097A6B
local other_start, other_end   = 0x097A6C, 0x097A8B
local relics_start, relics_end = 0x097964, 0x097981

local hand_items_id_start, hand_items_id_end = 0x097A8D, 0x097B35

local levels = {
    0, 100, 250, 450, 700, 1000, 1350, 1750, 2200, 2700, 3250, 3850, 4500,
    5200, 5950, 6750, 7600, 8500, 9450, 10450, 11700, 13200, 15100, 17500,
    20400, 23700, 27200, 30900, 35000, 39500, 44500, 50000, 56000, 61500,
    68500, 76000, 84000, 92500, 101500, 110000
}

local function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

local function getNewStats(pos)
    local stats = {}
    stats.lvl = math.max(1, math.floor(pos/2))
    stats.heart = (5*stats.lvl)
    stats.hp = 70 + stats.heart
    stats.mp = 20
    if stats.lvl > stats.mp then
        -- stats.mp = math.floor(2.825*stats.lvl)
        stats.mp = round(2.825*stats.lvl)
    end
    stats.exp = levels[stats.lvl]
    -- stats.next = levels[stats.lvl+1]-stats.exp

    return stats
end

local function setStats(room)
    local stats = getNewStats(room.pos)

    if room.vs == 0x18 or room.vs == 0x38 then
        stats.hp = stats.hp*2
    end
    mainmemory.write_u32_le(0x097BA0, stats.hp) -- CurrentHp
    mainmemory.write_u32_le(0x097BA4, stats.hp) -- MaxHp
    -- mainmemory.write_u32_le(0x097BB0, stats.mp) -- CurrentMp
    mainmemory.write_u32_le(0x097BB4, stats.mp) -- MaxMp
    mainmemory.write_u32_le(0x097BA8, stats.heart) -- CurrentHearts
    mainmemory.write_u32_le(0x097BAC, stats.heart) -- MaxHearts

    mainmemory.write_u32_le(0x097BE8, stats.lvl) -- Level
    mainmemory.write_u32_le(0x097BEC, stats.exp) -- Experience
    mainmemory.write_u32_le(0x097BF0, 0x0)       -- Gold
end

local equips
local function getEquip(room)
    equips = {}
    local lucky = UTILS.random(1, 14) == 7
    -- Right Hand
    if lucky then
        equips.righthand = 168 -- Alucart sword
        equips.leftthand = 167 -- Alucart shield
        equips.body      = 89  -- Alucart Mail
    else
        equips.righthand = 100 + UTILS.random(2, 26)
        equips.leftthand =   0 + UTILS.random(6, 16)
        equips.body      =   0 + UTILS.random(1, body_end-body_start)
    end
    -- if room.pos == 0x40 then
        -- equips.leftthand = 166 -- add library card to escape debug room
    -- end

    equips.head = 26 + UTILS.random(1, head_end-head_start, {8}) -- ignore holy glasses
    if room.pos == 0x18 then
        equips.head = 34 -- Direct fight Richter add holy glasses
    elseif head == 34 then
        equips.head = 33
    end

    equips.cloak  = 48 + UTILS.random(1, cloak_end-cloak_start)
    equips.other1 = 57 + UTILS.random(1, other_end-other_start, {15, 16}) -- ignore gold & silver ring
    equips.other2 = 57 + UTILS.random(1, other_end-other_start, {15, 16, equips.other1-57})
    equips.subweapon = UTILS.random(0, 9)
    return equips
end

function SOTN.setEquip(room)
    -- Hands and Body, not great work :( require to enter menu for active new item
    -- Probably require write other address
    if not equips then
        equips = getEquip(room)
    end
    mainmemory.writebyte(0x097C00, equips.righthand) -- Right Hand
    mainmemory.writebyte(0x097C04, equips.leftthand) -- Left Hand
    mainmemory.writebyte(0x097C0C, equips.body)      -- Body
    mainmemory.writebyte(0x097C08, equips.head)      -- Head
    mainmemory.writebyte(0x097C10, equips.cloak)     -- Cloak
    mainmemory.writebyte(0x097C14, equips.other1)    -- Slot 1
    mainmemory.writebyte(0x097C18, equips.other2)    -- Slot 2
    mainmemory.writebyte(0x097BFC, equips.subweapon) -- Subweapon
end

local function setGold(value)
    value = value or 0x0
    mainmemory.write_u32_le(0x097BF0, value)
end

local function setInventory(from, to, value)
    value = value or 0x0
    for i in UTILS.range(from, to) do
        -- print(i, string.format("%X", tostring(i)))
        mainmemory.writebyte(i, value)
    end
end

local function addHandItems(room, castle2)
    local rh, lh = mainmemory.readbyte(0x097C00), mainmemory.readbyte(0x097C04)
    local add1 = UTILS.random(4, hand_end-hand_start)
    local add2 = UTILS.random(4, hand_end-hand_start, {add1, rh, lh})
    local add3 = UTILS.random(4, hand_end-hand_start, {add1, add2, rh, lh})
    local move1 = mainmemory.readbyte(hand_items_id_start+1)
    local move2 = mainmemory.readbyte(hand_items_id_start+2)
    local move3 = mainmemory.readbyte(hand_items_id_start+3)

    if castle2 then
        -- Fist of Tulkas, Gurthang, Alucard sword, Mablung Sword, Masamune, Vorpal blade, Crissaegrim, Yasatsuna
        local blade = UTILS.shuffle({120, 121, 123, 124, 140, 163, 164, 165})
        blade = blade[UTILS.random(1, #blade)]
        if blade ~= add1 and blade ~= add2 and blade ~= add3 then
            add1 = blade
        end
    end
    if (room.pos == 0x40 or room.pos == 0x48) and add1 ~= 166 and add2 ~= 166 and add3 ~= 166 then
        add3 = 166 -- add library card to escape debug room
    end
    -- print(hand_items_id_start+add1, add1)
    -- print(hand_items_id_start+add2, add2)
    -- print(hand_items_id_start+add3, add3)
    -- print(hand_items_id_start+1, move1)
    -- print(hand_items_id_start+2, move2)
    -- print(hand_items_id_start+3, move3)

    -- swap items id
    mainmemory.writebyte(hand_items_id_start+1, add1)
    mainmemory.writebyte(hand_items_id_start+2, add2)
    mainmemory.writebyte(hand_items_id_start+3, add3)
    mainmemory.writebyte(hand_items_id_start+add1, move1)
    mainmemory.writebyte(hand_items_id_start+add2, move2)
    mainmemory.writebyte(hand_items_id_start+add3, move3)

    -- setInventory(hand_start  + 0x1, hand_end)
    mainmemory.writebyte(hand_start+add1, 0x1)
    mainmemory.writebyte(hand_start+add2, 0x1)
    mainmemory.writebyte(hand_start+add3, 0x1)
end

function SOTN.setupGame(room, equipAdded)
    SOTN.setEquip(room)
    setStats(room)
    -- setGold()
    setInventory(hand_start  + 0x1, hand_end)
    setInventory(body_start  + 0x1, body_end)
    mainmemory.writebyte(alucart_mail, 0x0)
    setInventory(head_start  + 0x1, head_end)
    setInventory(cloak_start + 0x1, cloak_end)
    setInventory(other_start + 0x1, other_end)
    setInventory(relics_start, relics_end)

    local castle2 = mainmemory.readbyte(0x1E5458) > 0
    -- if is in SecondCastle add relics for escape
    if castle2 then
        if #room.addrelics == 0 then
            room.addrelics = {ROOMS.relics.GravityBoots, ROOMS.relics.FormOfMist}
        end
        client.addcheat('8003C4E6 1150') -- Save Palette
        print("Cheat: Save Palette 1150")
    else
        client.addcheat('8003C4E6 BCAA') -- Save Palette
        print("Cheat: Save Palette BCAA")
    end

    if room.vs == 0x18 or room.vs == 0x38 then
        room.addrelics = {ROOMS.relics.FaerieScroll, ROOMS.relics.SpiritOrb}
    end
    for i=1, #room.addrelics do
        -- print("Relic: " .. bizstring.hex(room.addrelics[i]), mainmemory.readbyte(room.addrelics[i]))
        mainmemory.writebyte(room.addrelics[i], 0x3)
    end

    addHandItems(room, castle2)
    print('Setup game done!')
end


local characterMap = {
    [0x43] = ',',
    [0x44] = '.',
    [0x46] = ':',
    [0x47] = ';',
    [0x48] = '?',
    [0x49] = '!',
    [0x4d] = '`',
    [0x4e] = '"',
    [0x4f] = '^',
    [0x51] = '_',
    [0x60] = '~',
    [0x66] = '\'',
    [0x69] = '(',
    [0x6a] = ')',
    [0x6d] = '[',
    [0x6e] = ']',
    [0x6f] = '{',
    [0x70] = '}',
    [0x7b] = '+',
    [0x7c] = '-'
}

local function readString(address, lenght)
    -- Original code by TalicZealot
    local digit = false
    local symbol = false
    value = ""
    for i = 0, (lenght or 31), 1 do
        local currentByte = mainmemory.readbyte(address + i)
        if currentByte == 255 or currentByte == 0 then
            break
        elseif currentByte == 130 then
            digit = true
        elseif currentByte == 129 then
            symbol = true
        else
            if digit then
                digit = false
                value = value .. (currentByte - 79)
            elseif symbol then
                symbol = false
                if characterMap[currentByte] then
                    value = value .. characterMap[currentByte]
                end
            elseif currentByte > 0 then
                value = value .. string.char(currentByte)
            end
        end
    end
    return bizstring.trim(value)
end

function SOTN.getSeed()
    local seed = readString(0x1A78B4)   -- default: Input RICHTER to play
    local preset = readString(0x1A78D4) -- default: as Richter Belmont.
    local ver = ""
    if preset and preset ~= "as Richter Belmont." then
        local ws = {}
        for w in preset:gmatch("%S+") do table.insert(ws, w) end
        if #ws > 0 then
            ver = ws[1]
            table.remove(ws, 1)
        end
        preset = table.concat(ws, ' ')
        if preset == "" then
            preset = "Custom"
        end
    end
    if seed and preset then
        -- seed = string.gsub(seed, "(Input RICHTER to play)", "Original")
        -- preset = string.gsub(preset, "(as Richter Belmont.)", "Original")
        seed = bizstring.replace(seed, "Input RICHTER to play", "Original")
        preset = bizstring.replace(preset, "as Richter Belmont.", "Original")
        if ver == "" then
            ver = readString(0x0DC196, 9) -- SLUS-00067
        end
        return table.concat({seed or "?", preset or "?", ver}, '\n')
    else
        return ""
    end
end

function SOTN.getCutScene()
    local maria   = mainmemory.readbyte(0x0A2988)
    local richter = mainmemory.readbyte(0x0FFCFC)
    return maria, richter
end


-- local function printInventoryID(from, to)
    -- local invt = {}
    -- for i in UTILS.range(from, to) do
        -- invt[string.format("%X", tostring(i))] = mainmemory.readbyte(i)
    -- end
    -- print(invt)
-- end
-- printInventoryID(0x097A8D, 0x097B35)


return SOTN
