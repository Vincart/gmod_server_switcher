surface.CreateFont("Dev-Font", {
    font = "CloseCaption_Bold",
    size = 40,
    weight = 500,
} )

surface.CreateFont("Dev-Font2", {
    font = "CloseCaption_Bold",
    size = 25,
    weight = 500,
} )

local colorTable = {
    ["dark"] = Color(31, 31, 31),
    ["dark_grey"] = Color(44, 44, 44),
    ["grey"] = Color(48, 48, 48),
    ["light_grey"] = Color(50, 50, 50),
    ["green"] = Color(0, 255, 0),
    ["red"] = Color(255, 0, 0),
}

net.Receive("Eventserveranfrage", function()
    local serverIP = net.ReadString()

    local InviteMain = vgui.Create("DPanel")
    InviteMain:SetSize(500, 300)
    InviteMain:Center()
    InviteMain:MakePopup()
    InviteMain.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, colorTable.dark)
        draw.SimpleText("Möchtest du auf den Eventserver wechseln?", "Dev-Font2", w * .5, 125, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local HeadLinePanel = vgui.Create("DPanel", InviteMain)
    HeadLinePanel:Dock(TOP)
    HeadLinePanel:SetTall(45)
    HeadLinePanel.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, colorTable.grey)
        draw.SimpleText("Eventserveranfrage", "Dev-Font", w * .5, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local BottomPanel = vgui.Create("Panel", InviteMain)
    BottomPanel:Dock(BOTTOM)
    BottomPanel:DockMargin(0, 5, 0, 0)
    BottomPanel:SetTall(55)

    local InviteAccept = vgui.Create("DButton",BottomPanel)
    InviteAccept:Dock(RIGHT)
    InviteAccept:SetText("")
    InviteAccept:SetTall(55)
    InviteAccept:SetWide(250)
    InviteAccept.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, colorTable.green)
        draw.SimpleText("Annehmen", "Dev-Font2", w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    InviteAccept.DoClick = function()
        permissions.AskToConnect(serverIP)
        InviteMain:Close()
    end

    local InviteDenie = vgui.Create("DButton",BottomPanel)
    InviteDenie:Dock(LEFT)
    InviteDenie:SetText("")
    InviteDenie:SetTall(55)
    InviteDenie:SetWide(250)
    InviteDenie.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, colorTable.red)
        draw.SimpleText("Ablehnen", "Dev-Font2", w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    InviteDenie.DoClick = function()
        InviteMain:Close()
    end
end)

concommand.Add("eventinviteopen", function()
    local mainframe = vgui.Create("DFrame")
    mainframe:SetSize(ScrW() * .4, ScrH() * .5)
    mainframe:Center()
    mainframe:MakePopup()
    mainframe:SetMouseInputEnabled(true)
    mainframe.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, colorTable.light_grey)
    end

    local PlayerList = vgui.Create("DListView", mainframe)
    PlayerList:Dock(FILL)
    PlayerList:DockMargin(0, 0, 0, 25)
    PlayerList:AddColumn("Spieler")
    PlayerList.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, colorTable.dark_grey)
    end

    local lines = {}

    for k, v in ipairs(player.GetAll()) do
        local line = PlayerList:AddLine(v:GetName())
        lines[line] = ply
    end

    local ButtonPanel = vgui.Create("Panel", mainframe)
    ButtonPanel:Dock(BOTTOM)
    ButtonPanel:SetTall(50)

    local InviteButton = vgui.Create("DButton", ButtonPanel)
    InviteButton:Dock(RIGHT)
    InviteButton:SetTall(50)
    InviteButton:SetWide(200)
    InviteButton:SetText("Senden")
    InviteButton.DoClick = function()
        local tbl = {}
        for k, v in pairs(PlayerList:GetSelected()) do
            table.insert(tbl, lines[v])
        end
        net.Start("Eventserveranfrage")
        net.WriteUInt(#tbl, 7)
        for i = 1, #tbl do
            net.WriteEntity(tbl[i])
        end
        net.SendToServer()
        mainframe:Close()
    end

    local AbortButton = vgui.Create("DButton", ButtonPanel)
    AbortButton:Dock(LEFT)
    AbortButton:SetTall(50)
    AbortButton:SetWide(200)
    AbortButton:SetText("Abbrechen")
    AbortButton.DoClick = function()
        mainframe:Close()
    end
end)
