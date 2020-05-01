AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua")
include( "shared.lua" )

function ENT:Initialize()

	self:SetModel("models/weapons/w_missile_closed.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	self:SetGravity(0.05)
	self.currTail = 0

	phys = self:GetPhysicsObject()

	if phys and phys:IsValid() then
		phys:Wake()
	end

	//util.SpriteTrail( self, 0, Color( math.random(10,255), math.random(10,255), math.random(10,255) ), false, 10, 1, 4, 1 / ( 15 + 1 ) * 0.5, "trails/smoke" )

end

function ENT:SetupTrail(teamNum)

	local redCol = Color(255, 0, 0)
	local bluCol = Color(0, 0, 255)

	if (teamNum == 2) then
		self.currTail = util.SpriteTrail( self, 0, redCol, false, 10, 1, 4, 1 / ( 15 + 1 ) * 0.5, "trails/smoke" )
	end

	if (teamNum == 3) then
		self.currTail = util.SpriteTrail( self, 0, bluCol, false, 10, 1, 4, 1 / ( 15 + 1 ) * 0.5, "trails/smoke" )
	end

end

function ENT:UpdateTrail(teamNum)
	SafeRemoveEntity(self.currTail)
	self.currTail = util.SpriteTrail( self, 0, team.GetColor(teamNum), false, 10, 1, 4, 1 / ( 15 + 1 ) * 0.5, "trails/smoke" )
end

function ENT:OnTakeDamage(dmg)
end

function ENT:Use( activator )
end

function ENT:Touch(entity)
	if (entity:GetClass() == "ent_primary") then return end

	if (entity:GetClass() == "player") then
		util.BlastDamage( self, self:GetOwner(), self:GetPos(), 500, 1000 )
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "Explosion", effectdata )
		self:StopSound("weapons/rpg/rocket1.wav")
		self:Remove()
		return
	end

	if (entity:GetClass() == "worldspawn") then
		self:DoExplode()
	end

end

function ENT:DoExplode()
	util.BlastDamage( self, self:GetOwner(), self:GetPos(), 500, 115 )
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( "Explosion", effectdata )
	self:StopSound("weapons/rpg/rocket1.wav")
	self:Remove()
end

function ENT:StopMissile()
	self:SetVelocity(-self:GetVelocity())
end
