include( "shared.lua" );
include( "round_controller/cl_round_controller.lua" );


local hide = {
	["CHudCrosshair"] = true
}
local wave = Material( "materials/wireframe" )
hook.Add("PostDrawOpaqueRenderables", "awdasdwasdwadw", function()
    render.SetMaterial(wave)
    render.DrawBox( Vector(-165, -2056, -11071), Angle(0, 0, 0), Vector(0, 0, 0), Vector(100, 100, 100), Color( 255, 255, 255 ) )
end)

/*hook.Add( "HUDShouldDraw", "HideHUD", function( name )

    if (!LocalPLayer():Team():IsValid()) then return end

    if (LocalPlayer():Team() != 1) then return end

    if ( hide[ name ] ) then return false end
    
end )*/