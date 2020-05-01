local gameStatus = 0;

util.AddNetworkString("GameStatus")

function broadcastRoundStatus()
    net.Start("GameStatus")
        net.WriteInt(gameStatus, 4)
    net.Broadcast()
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
