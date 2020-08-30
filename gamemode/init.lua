AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "round_controller/cl_round_controller.lua" );
AddCSLuaFile( "settings.lua" )

include( "shared.lua" );
include( "round_controller/sv_round_controller.lua" );
include( "settings.lua" )
include( "extra/sv_bunnyhop.lua" )

playerMeta = FindMetaTable("Player");

local zoneStats = {};

function GM:Initialize()
    // load settings
    local allPoints = SETTINGS.MAP_POINTS[game.GetMap()];

    for i=1, #allPoints do
        zoneStats[i] = { redcap = 0, bluecap = 0, redplys = 0, blueplys = 0, owner = 0 };
    end

end



function playerMeta:SpawnLoadout()
    for i=1, #SETTINGS.WEAPONS do
        self:Give(SETTINGS.WEAPONS[i]);
    end
end

function playerMeta:JoinSpectator()
    self:SetTeam(1);
    self:Spectate(OBS_MODE_ROAMING);
    self:StripWeapons();
    self:SetModel("");
end

function playerMeta:JoinRedTeam()
    self:SetTeam(2);
    self:Spectate(OBS_MODE_NONE);
    self:SetModel("models/player/combine_super_soldier.mdl");
    self:Spawn();
end

function playerMeta:JoinBlueTeam()
    self:SetTeam(3);
    self:Spectate(OBS_MODE_NONE);
    self:SetModel("models/player/combine_soldier.mdl");
    self:Spawn();
end


function GM:PlayerConnect(name, ip)
    print( name.." has connected to the server with the IP "..ip.."." );
end

function GM:PlayerInitialSpawn(ply)

    print("Player "..ply:Nick().." has spawned for the first time.");

    timer.Simple(1, function()

        net.Start("OnConnectInfo");
            net.WriteTable(zoneStats);
        net.Send(ply);

        ply:JoinSpectator();
    end)
end

function GM:PlayerSpawn(ply)

    if (ply:Team() != 1) then
        ply:SpawnLoadout();
        ply:SetPos(SETTINGS.MAP_SPAWNS[game.GetMap()][math.random(#SETTINGS.MAP_SPAWNS[game.GetMap()])]);
    end

end

function GM:CanPlayerSuicide(ply)
    if (ply:Team() == 1) then
        return false;
    else
        return true;
    end
end

function GM:PlayerNoClip(ply, desiredState )
    if (ply:Team() == 1) then
        return false;
    else
        return true;
    end
end

function GM:GetFallDamage( ply, speed )
    return 0;
end

concommand.Add("teamred", function(ply)
    ply:JoinRedTeam();
end)

concommand.Add("teamblu", function(ply)
    ply:JoinBlueTeam();
end)

concommand.Add("teamspec", function(ply)
    ply:JoinSpectator();
end)

function GM:PlayerHurt(victim, attacker, healthRemaining, damageTaken)
    if (attacker:IsPlayer()) then
        if (attacker:Team() == victim:Team()) then
            return 0;
        end
    end
end


timer.Create("PointCounter", 1, 0, function()

    local currMap = game.GetMap();
    local zones = SETTINGS.MAP_POINTS[currMap];

    for z=1, #zones do

        local boxEnts = ents.FindInBox(zones[z][1], zones[z][1] + zones[z][2]);

        // clear previous counts
        zoneStats[z].redplys = 0;
        zoneStats[z].blueplys = 0;

        for i=1, #boxEnts do
            if boxEnts[i]:IsPlayer() then

                if (boxEnts[i]:Alive()) then

                    local ply = boxEnts[i];
                    local playerTeam = ply:Team();

                    if (playerTeam == 2) then // if red team
                        zoneStats[z].redplys = zoneStats[z].redplys + 1;
                    end

                    if (playerTeam == 3) then // if blue team
                        zoneStats[z].blueplys = zoneStats[z].blueplys + 1;
                    end

                end

            end
        end
            // capturing logic
            if (zoneStats[z].redplys > zoneStats[z].blueplys) then // if more red
                if (zoneStats[z].bluecap > 0) then // if there is already existing points from blue capture
                    zoneStats[z].bluecap = zoneStats[z].bluecap - 1; // remove one point from blue per "tick"
                else
                    if (zoneStats[z].redcap < SETTINGS.ROUNDINFO.CAPTURETIME) then // else add one to reds capture points
                        zoneStats[z].redcap = zoneStats[z].redcap + 1;
                    end
                end
            end

            // same as above but switched around
            if (zoneStats[z].blueplys > zoneStats[z].redplys) then

                if (zoneStats[z].redcap > 0) then
                    zoneStats[z].redcap = zoneStats[z].redcap - 1;
                else
                    if (zoneStats[z].bluecap < SETTINGS.ROUNDINFO.CAPTURETIME) then
                        zoneStats[z].bluecap = zoneStats[z].bluecap + 1;
                    end
                end
            end

        //PrintTable(zoneStats[z]);

    end

    for o=1, #zoneStats do

        if (zoneStats[o].redcap == SETTINGS.ROUNDINFO.CAPTURETIME) then

            if (zoneStats[o].owner != 1) then
                broadcastZoneOwners(o, 1);
                zoneStats[o].owner = 1;
            end

        end

        if (zoneStats[o].bluecap == SETTINGS.ROUNDINFO.CAPTURETIME) then

            if (zoneStats[o].owner != 2) then
                broadcastZoneOwners(o, 2);
                zoneStats[o].owner = 2;
            end

        end

        if (zoneStats[o].bluecap == 0 && zoneStats[o].redcap == 0) then

            if (zoneStats[o].owner != 0) then
                broadcastZoneOwners(o, 0);
                zoneStats[o].owner = 0;
            end

        end

        if (zoneStats[o].owner == 1) then
            addRedPoints(1);
            broadcastPoints();
        end

        if (zoneStats[o].owner == 2) then
            addBluePoints(1);
            broadcastPoints();
        end

        broadcastCaptureProgress(zoneStats[o].redcap, zoneStats[o].bluecap, o);

    end

end)