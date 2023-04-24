util.AddNetworkString("Eventserveranfrage")

net.Receive("Eventserveranfrage", function(len, ply)
    if not svsw_allowedranks[ply:GetUserGroup()] then
        return
    end

    local players = {}

    local tableLength = net.ReadUInt(7)

    for i = 1, tableLength do
        local pl = net.ReadEntity()
        table.insert(players, pl)
    end

    net.Start("Eventserveranfrage")
    net.WriteString(svsw_serverIP)
    net.Send(players)
end)
