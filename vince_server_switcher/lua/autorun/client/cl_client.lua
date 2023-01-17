surface.CreateFont("Dev-Fond", {
    font = "CloseCaption_Bold",
    size = 40,
    weight = 500,
} )

surface.CreateFont("Dev-Fond2", {
    font = "CloseCaption_Bold",
    size = 25,
    weight = 500,
} )

net.Receive("Eventserveranfrage", function()
    local serverIP = net.ReadString()

    local InviteMain = vgui.Create("DPanel")
    InviteMain:SetSize(500, 300)
    InviteMain:Center()
    InviteMain:MakePopup()
    InviteMain.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(31, 31, 31))
        draw.SimpleText("Möchtest du auf den Eventserver wechseln?", "Dev-Fond2", w * .5, 125, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local HeadLinePanel = vgui.Create("DPanel", InviteMain)
    HeadLinePanel:Dock(TOP)
    HeadLinePanel:SetTall(45)
    HeadLinePanel.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(48, 48, 48))
        draw.SimpleText("Eventserveranfrage", "Dev-Fond", w * .5, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
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
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0))
        draw.SimpleText("Annehmen", "Dev-Fond2", w * .5, h * .5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    InviteAccept.DoClick = function()
        permissions.AskToConnect(serverIP)
        InviteMain:Remove()
    end

    local InviteDenie = vgui.Create("DButton",BottomPanel)
    InviteDenie:Dock(LEFT)
    InviteDenie:SetText("")
    InviteDenie:SetTall(55)
    InviteDenie:SetWide(250)
    InviteDenie.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
        draw.SimpleText("Ablehnen", "Dev-Fond2", w * .5, h * .5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    InviteDenie.DoClick = function()
        InviteMain:Remove()
    end
end)

concommand.Add("eventinviteopen", function()

    local mainframe = vgui.Create("DFrame")
    mainframe:SetSize(ScrW() * .4, ScrH() * .5)
    mainframe:Center()
    mainframe:MakePopup()
    mainframe:SetMouseInputEnabled(true)
    mainframe.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50))
    end

    local PlayerList = vgui.Create("DListView", mainframe)
    PlayerList:Dock(FILL)
    PlayerList:DockMargin(0, 0, 0, 25)
    PlayerList:AddColumn("Spieler")
    PlayerList.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(44, 44, 44))
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
        for k, v in pairs(PlayerList:GetLines()) do
            if v:IsLineSelected() then
                table.insert(tbl, v.ply)
            end
        end
        net.Start("Eventserveranfrage")
        net.WriteUInt(#tbl, 7)
        for i = 1, #tbl do
            net.WriteEntity(tbl[i])
        end
        net.SendToServer()
        mainframe:Close()
    end

    local AbbortButton = vgui.Create("DButton", ButtonPanel)
    AbbortButton:Dock(LEFT)
    AbbortButton:SetTall(50)
    AbbortButton:SetWide(200)
    AbbortButton:SetText("Abbrechen")
    AbbortButton.DoClick = function()
        mainframe:Close()
    end

    for k, v in pairs(player.GetAll()) do
         local line = PlayerList:AddLine(v:GetName())
         line.ply = v
    end
end)
