--[=[
HealersHaveToDie World of Warcraft Add-on
Copyright (c) 2009 by John Wellesz (Archarodim@teaser.fr)
All rights reserved

Version 1.0.2

This is a very simple and light add-on that rings when you hover or target a
unit of the opposite faction who healed someone during the last 60 seconds (can
be configured).
Now you can spot those nasty healers instantly and help them to accomplish their destiny!

This add-on uses the Ace3 framework.

type /hhtd to get a list of existing options.

-----
    utils.lua
-----


--]=]


local HHTD_C = hhtd.C;

function hhtd:ColorText (text, color) --{{{
    return "|c".. color .. text .. "|r";
end --}}}



local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS;
HHTD_C.ClassesColors = { };

function hhtd:GetClassColor (EnglishClass)
    if not HHTD_C.ClassesColors[EnglishClass] then
        if RAID_CLASS_COLORS and RAID_CLASS_COLORS[EnglishClass] then
            HHTD_C.ClassesColors[EnglishClass] = { RAID_CLASS_COLORS[EnglishClass].r, RAID_CLASS_COLORS[EnglishClass].g, RAID_CLASS_COLORS[EnglishClass].b };
        else
            HHTD_C.ClassesColors[EnglishClass] = { 0.63, 0.63, 0.63 };
        end
    end
    return unpack(HHTD_C.ClassesColors[EnglishClass]);
end

HHTD_C.HexClassColor = { };

function hhtd:GetClassHexColor(EnglishClass)

    if not HHTD_C.HexClassColor[EnglishClass] then

        local r, g, b = self:GetClassColor(EnglishClass);

        HHTD_C.HexClassColor[EnglishClass] = ("FF%02x%02x%02x"):format( r * 255, g * 255, b * 255);

    end

    return HHTD_C.HexClassColor[EnglishClass];
end


function hhtd:CreateClassColorTables ()
    if RAID_CLASS_COLORS then
        local class, colors;
        for class in pairs(RAID_CLASS_COLORS) do
            if not class:find(" ") then -- thank to a wonderful add-on that adds the wrong translation "Death Knight" to the global RAID_CLASS_COLORS....
                hhtd:GetClassHexColor(class);
            else
                RAID_CLASS_COLORS[class] = nil; -- Eat that!
            end
        end
    else
        hhtd:Debug("global RAID_CLASS_COLORS does not exist...");
    end
end

