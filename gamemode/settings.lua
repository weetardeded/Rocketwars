SETTINGS = {};
SETTINGS.MAP_POINTS = {};
SETTINGS.MAP_SPAWNS = {};
SETTINGS.ROUNDINFO = {};

//start weapons
SETTINGS.WEAPONS = {
    "weapon_rocketlauncher"
};

// Make sure that the map name is actually the map name of the bsp file.
SETTINGS.MAP_POINTS["gm_bigcity"] = {
    [1] = { Vector(-10559, -191, -11135), Vector(2685, 2685, 1500), "A" },
    [2] = { Vector(7793, 9103, -10890), Vector(2685, 2685, 1500), "B" },
    [3] = { Vector(8711, -8337, -11135), Vector(2685, 2685, 1500), "C" }
};

SETTINGS.MAP_SPAWNS["gm_bigcity"] = { Vector(-1526, -6724, 512), Vector(-1226, -6724, 512), Vector(-926, -6724, 512), Vector(-626, -6724, 512) };


SETTINGS.ROUNDINFO.ROUNDTIME = 900; // 15 mins
SETTINGS.ROUNDINFO.MAXPOINTS = 1000;
SETTINGS.ROUNDINFO.CAPTURETIME = 10;

