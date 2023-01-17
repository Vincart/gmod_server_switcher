util.AddNetworkString("Eventserveranfrage")

net.Receive("Eventserveranfrage", function(len, ply)
    if not svsw_allowedranks[ply:GetUserGroup()] then
        return
    end

    local players = {}

    local tableLength = net.ReadUInt(7)

    for i = 1, tableLength do
        local playerr = net.ReadEntity()
        table.insert(players, playerr)
    end

    net.Start("Eventserveranfrage")
    net.WriteString(svsw_serverIP)
    net.Send(players)
end)
