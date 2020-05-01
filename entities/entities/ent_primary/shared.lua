ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Primary Missile"
ENT.Author = "GVRBVNZX"
ENT.Category = "Rocket Launcher"

ENT.Spawnable			= true
ENT.AdminOnly			= false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "RocketID")
end