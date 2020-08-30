local gameStatus = 0;
local redPoints = 0;
local bluePoints = 0;

util.AddNetworkString("Points");
util.AddNetworkString("GameStatus");
util.AddNetworkString("UpdateZoneOwners");
util.AddNetworkString("OnConnectInfo");
util.AddNetworkString("UpdateCapturePoints");

function broadcastCaptureProgress(redpoints, bluepoints, zoneID)
    net.Start("UpdateCapturePoints");
        net.WriteInt(redpoints, 9);
        net.WriteInt(bluepoints, 9);
        net.WriteInt(zoneID, 5);
    net.Broadcast();
end

function broadcastZoneOwners(zoneID, owner)
    net.Start("UpdateZoneOwners");
        net.WriteInt(zoneID, 4);
        net.WriteInt(owner, 4);
    net.Broadcast();
end

function broadcastPoints()
    net.Start("Points");
        net.WriteInt(redPoints, 12);
        net.WriteInt(bluePoints, 12);
    net.Broadcast();
end

function addRedPoints(pointsToAdd)
    redPoints = redPoints + pointsToAdd;
end

function addBluePoints(pointsToAdd)
    bluePoints = bluePoints + pointsToAdd;
end

function broadcastRoundStatus()
    net.Start("GameStatus");
        net.WriteInt(gameStatus, 4);
    net.Broadcast();
end

function getGameStatus()
    return gameStatus;
end

function startPreGame()
    gameStatus = 0;
    broadcastRoundStatus();
end

function startGame()
    gameStatus = 1;
    broadcastRoundStatus();
end

function startEndGame()
    gameStatus = 2;
    broadcastRoundStatus();
end
