-- Written by Frost


ROOMS = {}


package.loaded["./resources/libs/utils"] = nil
UTILS = require("./resources/libs/utils")


ROOMS.relics = {
    SoulOfBat     = 0x97964,
    FireOfBat     = 0x97965,
    EchoOfBat     = 0x97966,
    ForceOfEcho   = 0x97967,
    SoulOfWolf    = 0x97968,
    PowerOfWolf   = 0x97969,
    SkillOfWolf   = 0x9796A,
    FormOfMist    = 0x9796B,
    PowerOfMist   = 0x9796C,
    GasCloud      = 0x9796D,
    CubeOfZoe     = 0x9796E,
    SpiritOrb     = 0x9796F,
    GravityBoots  = 0x97970,
    LeapStone     = 0x97971,
    HolySymbol    = 0x97972,
    FaerieScroll  = 0x97973,
    JewelOfOpen   = 0x97974,
    MermanStatue  = 0x97975,
    BatCard       = 0x97976,
    GhostCard     = 0x97977,
    FaerieCard    = 0x97978,
    DemonCard     = 0x97979,
    SwordCard     = 0x9797A,
    SpriteCard    = 0x9797B,
    NoseDevilCard = 0x9797C,
    HeartOfVlad   = 0x9797D,
    ToothOfVlad   = 0x9797E,
    RibOfVlad     = 0x9797F,
    RingOfVlad    = 0x97980,
    EyeOfVlad     = 0x97981,
}

-- https://guides.gamercorner.net/sotn/maps/
-- https://guides.gamercorner.net/sotn/maps/inverted
ROOMS.rooms = {
    [1] = {
        desc="In Enter Marble Gallery",
        addrelics={},
        map={x=21, y=22},
        pos=0x0,
    },
    [2] = {
        desc="In Enter Outer Wall",
        addrelics={},
        map={x=60, y=21},
        pos=0x1,
    },
    [3] = {
        desc="In Enter Long Library",
        addrelics={},
        map={x=57,y=17},
        pos=0x2,
    },
    [4] = {
        desc="In Enter Catacombs",
        addrelics={ROOMS.relics.GravityBoots},
        map={x=30, y=45},
        pos=0x3,
    },
    [5] = {
        desc="In Enter Olrox's Quarters",
        addrelics={},
        map={x=28, y=21},
        pos=0x4,
    },
    [6] = {
        desc="In Enter Abandoned Mine",
        addrelics={ROOMS.relics.GravityBoots},
        map={x=26, y=34},
        pos=0x5,
    },
    [7] = {
        desc="In Enter Royal Chapel",
        addrelics={},
        map={x=2, y=24},
        pos=0x6,
    },
    [8] = {
        desc="On Exiting, between Marble Gallery to Entrance",
        addrelics={},
        map={x=18, y=32},
        pos=0x7,
    },
    [9] = {
        desc="Elevator to Maria",
        addrelics={},
        map={x=31, y=24},
        pos=0x8,
    },
    [10] = {
        desc="In Enter Underground Caverns",
        addrelics={ROOMS.relics.GravityBoots},
        map={x=38, y=22},
        pos=0x9,
    },
    [11] = {
        desc="In Enter Colosseum",
        addrelics={},
        map={x=24, y=18},
        pos=0xA,
    },
    [12] = {
        desc="On Exiting, between Royal Chapel to Castle Keep",
        addrelics={},
        map={x=29, y=8},
        pos=0xB,
    },
    [13] = {
        desc="In Enter Alchemy Laboratory",
        addrelics={},
        map={x=15, y=32},
        pos=0xC,
    },
    [14] = {
        desc="In Enter Clock Tower",
        addrelics={},
        map={x=58, y=10},
        pos=0xD,
    },
    [15] = {
        desc="In wrap room of Castle Keep",
        addrelics={},
        map={x=39, y=8},
        pos=0xE,
    },
    [16] = {
        desc="In Outer Wall, In falling beside of Skeleton Ape",
        addrelics={},
        map={x=59, y=15},
        pos=0xF,
    },
    [17] = {
        desc="In Marble Gallery, falling beside door of room between Entrance and Ctulhu",
        addrelics={},
        map={x=20, y=32},
        pos=0x10,
    },
    [18] = {
        desc="In Outer Wall, In falling beside of Skeleton Ape",
        addrelics={},
        map={x=59, y=15},
        pos=0x11,
    },
    [19] = {
        desc="In Nightmare of fight Succubus",
        addrelics={},
        map={x=44, y=29},
        pos=0x12,
    },
    [20] = {
        desc="In Room of fight Slogra and Gaibon",
        addrelics={},
        map={x=8, y=23},
        pos=0x13,
    },
    [21] = {
        desc="In Room of fight Karasuman",
        addrelics={},
        map={x=39, y=6},
        pos=0x14,
    },
    [22] = {
        desc="In Long Library between Save room and before fight Lesser Demon",
        addrelics={},
        map={x=47, y=15},
        pos=0x15,
    },
    [23] = {
        desc="In Room of fight Cerberos",
        addrelics={ROOMS.relics.GravityBoots},
        map={x=29, y=36},
        pos=0x16,
    },
    [24] = {
        desc="In Clock room, in talk Maria",
        addrelics={},
        map={x=31, y=22},
        pos=0x17,
    },
    [25] = {
        desc="In Room of fight Richter",
        addrelics={},
        map={x=32, y=4},
        pos=0x18,
    },
    [26] = {
        desc="In Room of fight Hippogryph",
        addrelics={},
        map={x=22, y=9},
        pos=0x19,
    },
    [27] = {
        desc="In Room of fight Doppleganger10",
        addrelics={},
        map={x=56, y=19},
        pos=0x1A,
    },
    [28] = {
        desc="In Room of fight Scylla wyrm",
        addrelics={},
        map={x=40, y=34},
        pos=0x1B,
    },
    [29] = {
        desc="In Room of fight Minotaur and Werewolf",
        addrelics={},
        map={x=18, y=18},
        pos=0x1C,
    },
    [30] = {
        desc="In Room of fight Granfaloon",
        addrelics={ROOMS.relics.GravityBoots},
        map={x=18, y=46},
        pos=0x1D,
    },
    [31] = {
        desc="In Room of fight Olrox",
        addrelics={ROOMS.relics.GravityBoots, ROOMS.relics.SoulOfWolf},
        map={x=19, y=12},
        pos=0x1E,
    },
    [32] = {
        desc="Final Stage: Bloodlines",
        addrelics={},
        map={x=3, y=5},
        pos=0x1F,
    },
    [33] = {
        desc="On Exiting, between Necromancy Laboratory to Black Marble Gallery",
        addrelics={},
        map={x=40, y=26, inv=2},
        pos=0x20,
    },
    [34] = {
        desc="On Exiting, between Black Marble Gallery to Reverse Outer Wall",
        addrelics={},
        map={x=1, y=27, inv=2},
        pos=0x21,
    },
    [35] = {
        desc="On Exiting, between Reverse Outer Wall to Black Marble Gallery",
        addrelics={},
        map={x=3, y=27, inv=2},
        pos=0x22,
    },
    [36] = {
        desc="On Exiting, between Cave to Floating Catacombs",
        addrelics={},
        map={x=31, y=3, inv=2},
        pos=0x23,
    },
    [37] = {
        desc="On Exiting, between Black Marble Gallery to Death Wing's Lair",
        addrelics={},
        map={x=33, y=27, inv=2},
        pos=0x24,
    },
    [38] = {
        desc="On Exiting, between Reverce Caverns to Cave",
        addrelics={},
        map={x=35, y=14, inv=2},
        pos=0x25,
    },
    [39] = {
        desc="On Exiting, between Necromancy Laboratory to Anti-Chapel",
        addrelics={},
        map={x=59, y=24, inv=2},
        pos=0x26,
    },
    [40] = {
        desc="On Exiting, between Black Marble Gallery to Reverse Entrance",
        addrelics={},
        map={x=43, y=16, inv=2},
        pos=0x27,
    },
    [41] = {
        desc="Elevator to Shaft",
        addrelics={},
        map={x=30, y=24, inv=2},
        pos=0x28,
    },
    [42] = {
        desc="On Exiting, between Black Marble Gallery to Reverce Caverns",
        addrelics={},
        map={x=23, y=26, inv=2},
        pos=0x29,
    },
    [43] = {
        desc="On Exiting, between Death Wing's Lair to Reverce Colosseum",
        addrelics={},
        map={x=37, y=30, inv=2},
        pos=0x2A,
    },
    [44] = {
        desc="On Exiting, between Anti-Chapel to Reverce Keep",
        addrelics={},
        map={x=32, y=40, inv=2},
        pos=0x2B,
    },
    [45] = {
        desc="On Exiting, between Reverse Entrance to Necromancy Laboratory",
        addrelics={},
        map={x=46, y=16, inv=2},
        pos=0x2C,
    },
    [46] = {
        desc="On Exiting, between Reverse Outer Wall to Reverse Clock Tower",
        addrelics={},
        map={x=3, y=38, inv=2},
        pos=0x2D,
    },
    [47] = {
        desc="In wrap room of Reverce Keep",
        addrelics={},
        map={x=22, y=40, inv=2},
        pos=0x2E,
    },
    [48] = {
        desc="Glitch: In Outer Wall, beside switch to activate the elevator",
        addrelics={},
        map={x=59, y=4, inv=3},
        pos=0x2F,
    },
    [49] = {
        desc="Glitch: In Outer Wall, beside switch to activate the elevator",
        addrelics={},
        map={x=59, y=4, inv=3},
        pos=0x30,
    },
    [50] = {
        desc="Glitch: In Outer Wall, beside switch to activate the elevator",
        addrelics={},
        map={x=59, y=4, inv=3},
        pos=0x31,
    },
    [51] = {
        desc="Glitch: In room between Outer Wall to reverse wrap room",
        addrelics={},
        map={x=59, y=6, inv=3},
        pos=0x32,
    },
    [52] = {
        desc="Glitch: In room between Outer Wall to Forbidden Library",
        addrelics={},
        map={x=58, y=10, inv=3},
        pos=0x33,
    },
    [53] = {
        desc="Glitch: On Exiting, between Outer Wall to reverse wrap room",
        addrelics={},
        map={x=3, y=35, inv=3},
        pos=0x34,
    },
    [54] = {
        desc="In room of fight Darkwing Bat",
        addrelics={},
        map={x=22, y=42, inv=2},
        pos=0x35,
    },
    [55] = {
        desc="In room of fight Galamoth",
        addrelics={},
        map={x=43, y=2, inv=2},
        pos=0x36,
    },
    [56] = {
        desc="In room of fight Akmodan II",
        addrelics={},
        map={x=42, y=36, inv=2},
        pos=0x37,
    },
    [57] = {
        desc="Final fight with Dracula",
        addrelics={},
        map={x=30, y=26, inv=-1},
        pos=0x38,
    },
    [58] = {
        desc="In room of fight Doppleganger40",
        addrelics={},
        map={x=22, y=13, inv=2},
        pos=0x39,
    },
    [59] = {
        desc="In room of fight The Creature",
        addrelics={},
        map={x=4, y=29, inv=2},
        pos=0x3A,
    },
    [60] = {
        desc="In room of fight Medusa",
        addrelics={},
        map={x=39, y=39, inv=2},
        pos=0x3B,
    },
    [61] = {
        desc="In room of fight Death",
        addrelics={},
        map={x=32, y=12, inv=2},
        pos=0x3C,
    },
    [62] = {
        desc="In room of fight Beezelbub",
        addrelics={},
        map={x=50, y=24, inv=2},
        pos=0x3D,
    },
    [63] = {
        desc="In room of fight Trevor, Grant and Sypha",
        addrelics={},
        map={x=43, y=30, inv=2},
        pos=0x3E,
    },
    [64] = {
        desc="In room zero: Unknown save room ???",
        addrelics={},
        map={x=58, y=13, inv=-1},
        pos=0x3F,
    },
    [65] = {
        desc='In Debug room (Use "Library Card" to escape!)',
        addrelics={},
        map={x=55, y=44},
        pos=0x40,
    },
    [66] = {
        desc="Default start, but intro skipped",
        addrelics={},
        map={x=1, y=36},
        pos=0x41,
    },
    [67] = {
        desc="Glitch: Outside Outer Wall to bad Marble Gallery",
        addrelics={},
        map={x=57, y=20.5},
        pos=0x42,
    },
    [68] = {
        desc="In room before librarian shop",
        addrelics={},
        map={x=49, y=16},
        pos=0x43,
    },
    [69] = {
        desc="In Enter Outer Wall",
        addrelics={},
        map={x=60, y=21},
        pos=0x44,
    },
    -- 0x45 to 0x47 = nil
    [70] = {
        desc='In Debug Marble Gallery (Use "Library Card" to escape!)',
        addrelics={},
        map={x=-1, y=19},
        pos=0x48,
    },
    -- 0x49 to 0x4A = nil
    -- 0x4B = Video saved Richter
    -- 0x4C to 0x65 = nil
    -- 0x66 to 0xFD not tested
    -- 0xFE = nil
}
ROOMS.descToIndex = {}
ROOMS.droplist = {}
for i=1, #ROOMS.rooms do
    local desc = string.format("%d. %s", i, ROOMS.rooms[i].desc)
    ROOMS.descToIndex[desc] = i
    ROOMS.droplist[i] = desc
end
-- print('*', ROOMS.descToIndex["In Enter Outer Wall"], '*')


-- local saveLastRoom = function(pos)
    -- local f = io.open('./.cache/sotn.log', "w")
    -- if not f then
        -- os.execute("mkdir .cache")
        -- f = io.open('./.cache/sotn.log', "w")
    -- end
    -- if f then
        -- f:write(pos)
        -- f:close()
    -- end
-- end

-- local loadLastRoom = function()
    -- local last = '0'
    -- local f = io.open('./.cache/sotn.log', "r")
    -- if f then
        -- last = f:read()
        -- f:close()
    -- end
    -- return tonumber(last)
-- end

function ROOMS.getRoom(pos)
    UTILS.setRandom()
    local room = ROOMS.rooms[0x1F+1]
    if pos == 'next' then
        local last = UTILS.settings.lastroom -- loadLastRoom()
        last = last + 1
        -- saveLastRoom(last)
        UTILS.settings.lastroom = last
        room = ROOMS.rooms[last]
    elseif pos then
        room = ROOMS.rooms[pos+1]
    else
        local last = UTILS.settings.lastroom -- loadLastRoom()
        for i=1, #ROOMS.rooms do
            room = ROOMS.rooms[math.random(#ROOMS.rooms)]
            if room.pos ~= last then
                -- saveLastRoom(room.pos)
                UTILS.settings.lastroom = room.pos
                break
            end
        end
    end
    room.vs = nil -- remove Richter Vs.
    return room
end


return ROOMS
