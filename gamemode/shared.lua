GM.Name = "Rocket Wars";
GM.Author = "GVRBVNZX";
GM.Email = "N/A";
GM.Website = "N/A";

function GM:Initialize()
    self.BaseClass.Initialize( self );
end

team.SetUp(1, "Spectator", Color(0, 0, 0), true);
team.SetUp(2, "Red", Color(255, 0, 0), true);
team.SetUp(3, "Blue", Color(0, 0, 255), true);
    
util.PrecacheModel("models/player/combine_soldier.mdl");
util.PrecacheModel("models/player/combine_super_soldier.mdl");