AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "round_controller/cl_round_controller.lua" );
AddCSLuaFile( "settings.lua" )

include( "shared.lua" );
include( "round_controller/sv_round_controller.lua" );
include( "settings.lua" )
include( "extra/sv_bunnyhop.lua" )

playerMeta = FindMetaTable("Player");


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
        ply:JoinSpectator();
    end)
end

function GM:PlayerSpawn(ply)

    if (ply:Team() != 1) then
        ply:SpawnLoadout();
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