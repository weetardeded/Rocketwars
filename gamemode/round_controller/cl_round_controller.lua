local roundStatus = 0;

net.Receive("GameStatus", function()
    roundStatus = net.ReadInt(4);
end)

function getRoundStatus()
    return roundStatus;
end