AddCSLuaFile()

// this is the worst code ive made in my entire life. holy fucking shit i hate making sweps.

SWEP.PrintName = "Rocket Launcher"
SWEP.Author = "GVRBVNZX"
SWEP.Purpose = "Mate, it's a rocket launcher"

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
	["base"] = { scale = Vector(1, 1, 1), pos = Vector(3.148, 16.851, -12.037), angle = Angle(0, 50, 0) }
}

function SWEP:Initialize()
	self:SetHoldType( "rpg" )

		self.restoreTime = 3;
		self.bt = {};
		self.bt[1] = 0;
		self.bt[2] = 0;
		self.bt[3] = 0;

		self.lastReload = 0;
		self.lastSecondShot = 0;

end

function SWEP:CanBePickedUpByNPCs()
	return false
end


if (CLIENT) then
	function clientExplosion(ent)
		local effectdata = EffectData()
		effectdata:SetOrigin( ent:GetPos() )
		util.Effect( "Explosion", effectdata )
	end
end


function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 1 )

	self:EmitSound( "weapons/grenade_launcher1.wav", 40 )
	self:ShootEffects( self )

	if ( CLIENT ) then return end

	local ent = ents.Create( "ent_primary" )
	if ( !IsValid( ent ) ) then return end

	local Forward = self.Owner:GetAimVector()
	ent:SetPos( self.Owner:GetShootPos() + Forward * 32 )
	ent:SetAngles( self.Owner:EyeAngles() )
	ent:SetOwner( self.Owner )
	ent:Spawn()
	ent:Activate()
	ent:SetupTrail(self.Owner:Team())
	ent:EmitSound("weapons/rpg/rocket1.wav")
	ent:SetVelocity( Forward * 2500 )
end





function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() + .5 )

	self:ShootEffects( self )

	if not IsFirstTimePredicted() then return end

		if (self.Owner:KeyDown(IN_USE)) then

			self:EmitSound("buttons/blip1.wav")

			if (SERVER) then
				for k, v in pairs(ents.FindByClass("ent_primary")) do
					local dist = self.Owner:GetPos():Distance(v:GetPos())
					local direction = self.Owner:GetAimVector()

					if (v:GetOwner() == self.Owner) then
						v:StopMissile()
						//v:SetAngles( self.Owner:EyeAngles() )
						v:SetAngles( (self.Owner:GetEyeTrace().HitPos - v:GetPos()):Angle() )
						timer.Simple(.02, function()
							v:SetVelocity((v:GetAngles():Forward() * 2500))
						end)
						
					else
						if (dist < 500) then // test dist
							v:SetOwner(self.Owner)
							v:StopMissile()
							v:SetAngles( self.Owner:EyeAngles() )
							timer.Simple(.02, function()
								v:SetVelocity((direction * 2500))
							end)
							v:UpdateTrail(self.Owner:Team())
						end
					end

				end
			end

			return;
		end

		if (SERVER) then
			if (CurTime() - self.bt[1] < self.restoreTime && CurTime() - self.bt[2] < self.restoreTime && CurTime() - self.bt[3] < self.restoreTime) then
				self:EmitSound("buttons/lightswitch2.wav") 
				return 
			end	
		end
		if (CLIENT) then
			if (CurTime() - self.bt[1] < self.restoreTime && CurTime() - self.bt[2] < self.restoreTime && CurTime() - self.bt[3] < self.restoreTime) then 
				self:EmitSound("buttons/lightswitch2.wav")
				return 
			end	
		end



		if (CurTime() - self.bt[1] > self.restoreTime) then
			self.Owner:SetVelocity(-self.Owner:GetAimVector() * (800 - (self.Owner:GetVelocity():Length() / 3)))
			self.bt[1] = CurTime();

			local effectdata = EffectData()
			effectdata:SetOrigin( self.Owner:GetPos() )
			util.Effect( "WaterSurfaceExplosion", effectdata )
			return;
		end

		if (CurTime() - self.bt[2] > self.restoreTime) then
			self.Owner:SetVelocity(-self.Owner:GetAimVector() * (800 - (self.Owner:GetVelocity():Length() / 3)))
			self.bt[2] = CurTime();

			local effectdata = EffectData()
			effectdata:SetOrigin( self.Owner:GetPos() )
			util.Effect( "WaterSurfaceExplosion", effectdata )
			return;
		end

		if (CurTime() - self.bt[3] > self.restoreTime) then
			self.Owner:SetVelocity(-self.Owner:GetAimVector() * (800 - (self.Owner:GetVelocity():Length() / 3)))
			self.bt[3] = CurTime();

			local effectdata = EffectData()
			effectdata:SetOrigin( self.Owner:GetPos() )
			util.Effect( "WaterSurfaceExplosion", effectdata )
			return;
		end


end





function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Reload()

	if (CLIENT) then

		if (CurTime() - self.lastReload < 1) then
			return
		end

		for k, v in pairs(ents.FindByClass("ent_primary")) do
			if (v:GetOwner() == LocalPlayer()) then
				clientExplosion(v);
			end
		end

		self.lastReload =  CurTime()

	end

	if (CLIENT) then return end

	if (CurTime() - self.lastReload < 1) then
		return
	end

	for k, v in pairs(ents.FindByClass("ent_primary")) do
		if (v:GetOwner() == self.Owner) then
			v:DoExplode()
		end
	end

	self.lastReload =  CurTime()
end



if (SERVER) then
	util.AddNetworkString("DamageReport")

	hook.Add( "EntityTakeDamage", "printdamage", function( target, dmginfo )
		if (!target:IsPlayer()) then return end
			net.Start("DamageReport")
			net.WriteFloat(dmginfo:GetDamage(), 10)
			net.WriteEntity(target)
			net.Send(dmginfo:GetAttacker())
	end )
end

if (CLIENT) then

	local damagePos = {};
	damagePos["damage"] = {};
	damagePos["pos"] = {};

	net.Receive("DamageReport", function()
		local dmg = math.floor(net.ReadFloat(10));
		table.insert(damagePos["damage"], dmg);

		local rEnt = net.ReadEntity();
		table.insert(damagePos["pos"], rEnt:GetPos());

		timer.Simple(1.5, function() 
			table.remove(damagePos["damage"], 1);
			table.remove(damagePos["pos"], 1);
		end)
	end)

	hook.Add("HUDPaint", "dillermand", function()
		for i=1, #damagePos["damage"] do
			draw.SimpleTextOutlined( damagePos["damage"][i], "CloseCaption_Normal", damagePos["pos"][i]:ToScreen().x, damagePos["pos"][i]:ToScreen().y, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255) );
		end
	end)
end
