include( "shared.lua" );
include( "round_controller/cl_round_controller.lua" );
include ( "settings.lua" );

local redPoints = 0;
local bluePoints = 0;
local zoneStats;


net.Receive("UpdateCapturePoints", function()

    if (!zoneStats) then return end

    local redpoints = net.ReadInt(9);
    local bluepoints = net.ReadInt(9);
    local zoneID = net.ReadInt(5);

    zoneStats[zoneID].redcap = redpoints;
    zoneStats[zoneID].bluecap = bluepoints;

end)

net.Receive("UpdateZoneOwners", function()
    local zoneID = net.ReadInt(4);
    local rOwner = net.ReadInt(4);

    zoneStats[zoneID].owner = rOwner;
end)

net.Receive("Points", function()
    redPoints = net.ReadInt(12);
    bluePoints = net.ReadInt(12);
end)

net.Receive("OnConnectInfo", function()
    local rTable = net.ReadTable();
    zoneStats = rTable;
end)


concommand.Add("showme", function()
    PrintTable(zoneStats);
end)

hook.Add("PostDrawOpaqueRenderables", "DrawCaptureBoxes", function()

    if (!zoneStats) then return end


    local currMap = game.GetMap();
    local mapPoints = SETTINGS.MAP_POINTS[currMap];

    for i=1, #mapPoints do
    
        local drawCol = Color(255, 255, 255, 255);

        if (zoneStats[i].owner == 1) then
            drawCol = team.GetColor(2);
        end

        if (zoneStats[i].owner == 2) then
            drawCol = team.GetColor(3);
        end



        render.DrawWireframeBox( mapPoints[i][1], Angle(0, 0, 0), Vector(0, 0, 0), mapPoints[i][2], drawCol, true );
    end
    
end)



hook.Add("HUDPaint", "DrawZoneStatus", function()

    if (!zoneStats) then return end

    local currMap = game.GetMap();
    local mapPoints = SETTINGS.MAP_POINTS[currMap];

    for i=1, #mapPoints do

        surface.SetDrawColor(team.GetColor(zoneStats[i].owner + 1));
        surface.DrawRect((mapPoints[i][1] + (mapPoints[i][2] / 2)):ToScreen().x - 7, (mapPoints[i][1] + (mapPoints[i][2] / 2)):ToScreen().y - 7, 19, 19);

        surface.SetDrawColor(50, 50, 50, 255);
        surface.DrawRect((mapPoints[i][1] + (mapPoints[i][2] / 2)):ToScreen().x - 5, (mapPoints[i][1] + (mapPoints[i][2] / 2)):ToScreen().y - 5, 15, 15);

    	surface.SetFont( "Default" );
	    surface.SetTextColor( 255, 255, 255 );
	    surface.SetTextPos( (mapPoints[i][1] + (mapPoints[i][2] / 2)):ToScreen().x, (mapPoints[i][1] + (mapPoints[i][2] / 2)):ToScreen().y - 3 );
	    surface.DrawText( mapPoints[i][3] );

    	surface.SetFont( "Default" );
	    surface.SetTextColor( 255, 0, 0 );
	    surface.SetTextPos( (mapPoints[i][1] + (mapPoints[i][2] / 2)):ToScreen().x, (mapPoints[i][1] + (mapPoints[i][2] / 2)):ToScreen().y - 20 );
	    surface.DrawText( ((zoneStats[i].redcap / SETTINGS.ROUNDINFO.CAPTURETIME) * 100) .. "%");

    	surface.SetFont( "Default" );
	    surface.SetTextColor( 0, 0, 255 );
	    surface.SetTextPos( (mapPoints[i][1] + (mapPoints[i][2] / 2)):ToScreen().x, (mapPoints[i][1] + (mapPoints[i][2] / 2)):ToScreen().y - 30 );
	    surface.DrawText( ((zoneStats[i].bluecap / SETTINGS.ROUNDINFO.CAPTURETIME) * 100) .. "%");

    end


    // point drawing
    surface.SetFont( "DermaLarge" );
	surface.SetTextColor( 255, 0, 0 );
	surface.SetTextPos( 25, 25 );
	surface.DrawText( redPoints );

    surface.SetFont( "DermaLarge" );
	surface.SetTextColor( 0, 0, 255 );
	surface.SetTextPos( 150, 25 );
	surface.DrawText( bluePoints );




    // enable later for testing
    for k, v in pairs(player.GetAll()) do
        if (v != LocalPlayer()) then
            local pos = v:GetPos();

            if (v:Team() == LocalPlayer():Team()) then
                surface.SetFont( "Default" );
                surface.SetTextColor( team.GetColor(v:Team()) );
                surface.SetTextPos( pos:ToScreen().x, pos:ToScreen().y );
                surface.DrawText( v:GetName() );
            end

        end
    end

end)

concommand.Add("aimpoint", function()
    print(LocalPlayer():GetEyeTrace().HitPos)
end)


/*
local hide = {
	["CHudCrosshair"] = true
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )

    if (!LocalPLayer():Team():IsValid()) then return end

    if (LocalPlayer():Team() != 1) then return end

    if ( hide[ name ] ) then return false end
    
end )*/