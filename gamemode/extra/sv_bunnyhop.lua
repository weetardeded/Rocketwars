/*if CLIENT then
	CreateClientConVar( "autojump", 1, true, true )
end 

local band = bit.band
local bor = bit.bor
local bnot = bit.bnot

hook.Add("SetupMove", "AutoJump", function(ply, uc)
	if CLIENT and GetConVarNumber( "autojump" ) ~= 1 then return end
	if SERVER and ply:GetInfoNum( "autojump", 1 ) ~= 1 then return end
	if ply:Alive() and ply:GetMoveType() == MOVETYPE_WALK and not ply:InVehicle() and ply:WaterLevel() <= 1 and band(uc:GetButtons(), IN_JUMP) == IN_JUMP then 
		if ply:IsOnGround() then
			uc:SetButtons( bor( uc:GetButtons(), IN_JUMP) )
		else
			uc:SetButtons( band( uc:GetButtons(), bnot(IN_JUMP)) )
		end
	end
end)
*/