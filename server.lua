local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('kibra-emlakv2:server:CheckCasePassword', function(Password)
    local dosya = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local veri = {}
    veri = json.decode(dosya)
    print(veri.EmlakPassword)
    print(Password)
    if Password == tonumber(veri.EmlakPassword) then
        TriggerClientEvent('kibra-emlakv2:client:OpenStash', source)
    else
       TriggerClientEvent("QBCore:Notify", source, "Kasa şifresini yanlış girdiniz!", 'error')
    end
end)

RegisterNetEvent('kibra-emlakv2:server:BlackMoneyWash', function(BlackMoneyCount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local dosya = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local veri = {}
    veri = json.decode(dosya)
    local TotalPara = BlackMoneyCount/KIBRA.BlackMoneyWashPrice
    local BlackMoneyItem = Player.Functions.GetItemByName("black_money")
    if BlackMoneyItem ~= nil then 
        if BlackMoneyItem.amount >= BlackMoneyCount then
            Player.Functions.RemoveItem("black_money", BlackMoneyCount)
            local information = {EmlakPassword = veri.EmlakPassword, EmlakName = veri.EmlakName, EmlakPara = veri.EmlakPara+TotalPara}
            SaveResourceFile(GetCurrentResourceName(), "EmlakData.json", json.encode(information), -1)
            TriggerClientEvent('QBCore:Notify', src, BlackMoneyCount..' tutarında karapara bozdurarak şirket hesabınıza $'..TotalPara..' eklendi!')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Yeteri kadar karaparanız yok!', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Yeteri kadar karaparanız yok!', 'error')
    end
end)

RegisterNetEvent('kibra-emlakv2:server:BuyHouse', function(HouseId, Target, Price)
    local Player = QBCore.Functions.GetPlayer(source)
    local xTarget = QBCore.Functions.GetPlayer(Target)
    local HousePassword = 'KBR_HOUSE'..math.random(111111,999999)
    if xTarget ~= nil then
        if xTarget.PlayerData.money["cash"] >= Price then
            local HouseBought = exports.oxmysql:executeSync('SELECT bought FROM kibra_houses WHERE houseno = ?', {HouseId})
            if #HouseBought > 0 then
                if HouseBought[1].bought == 0 then
                    TriggerClientEvent('kibra-emlakv2:client:CheckTargetMoney', Target, HouseId, Price, HousePassword, Player.PlayerData.source)
                else
                    TriggerClientEvent('QBCore:Notify', Target, 'Bu ev başka birine satılmış!', 'error')
                end
            end
        else
            TriggerClientEvent("QBCore:Notify", Target, "Paranız bu evi almak için yetersiz! ("..Price..")", 'error')
        end
    end
end)

RegisterNetEvent('kibra-emlakv2:server:HouseBuy', function(Target, HouseId, Price, HousePassword, PlySrc)
    local dosya = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local veri = {}
    veri = json.decode(dosya)
    local xTarget = QBCore.Functions.GetPlayer(Target)
    xTarget.Functions.RemoveMoney('cash', Price)
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local information = {EmlakPassword = veri.EmlakPassword, EmlakName = veri.EmlakName, EmlakPara = veri.EmlakPara+Price}
    exports.oxmysql:execute('UPDATE kibra_houses SET houseowner = ?, bought = ?, housepassword = ? WHERE houseno = ?', {xTarget.PlayerData.citizenid, 1, HousePassword, HouseId})
    TriggerEvent('kibra-houses:server:OwnerUpdate', HouseId, xTarget.PlayerData.citizenid, HousePassword)
    local info = {
        HouseNo = HouseId,
        HouseKeyPassword = HousePassword
    }
    xTarget.Functions.AddItem('housekeys', 1, nil, info)
    TriggerEvent('kibra-houses:server:RefreshHouses')
    TriggerClientEvent('QBCore:Notify', Target, 'Yeni bir ev satın aldınız! Ev Anahtarlarınız size teslim edildi!', 'success')
    TriggerClientEvent('QBCore:Notify', PlySrc, xTarget.PlayerData.charinfo.firstname..' '..xTarget.PlayerData.charinfo.lastname..' adlı kişiye '..HouseId..' numaralı daireyi sattınız!', 'success')
    TriggerClientEvent('QBCore:Notify', PlySrc, 'Emlak kasasına $'..Price..' eklendi!')
    TriggerClientEvent('kibra-houses:client:CreateHouseBlip', Target, HouseId)
end)

RegisterNetEvent('kibra-emlakv2:server:EmlakParaYatir', function(KacPara)
    local Player = QBCore.Functions.GetPlayer(source)
    local dosya = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local veri = {}
    veri = json.decode(dosya)
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local information = {EmlakPassword = veri.EmlakPassword, EmlakName = veri.EmlakName, EmlakPara = tonumber(veri.EmlakPara+KacPara)}
    if Player.PlayerData.money["cash"] >= tonumber(KacPara) then
        Player.Functions.RemoveMoney('cash', KacPara)
        SaveResourceFile(GetCurrentResourceName(), "EmlakData.json", json.encode(information), -1)
        TriggerClientEvent('QBCore:Notify', source, 'Kasaya $'..KacPara..' miktarında para yatırdınız!', 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Üzerinizde kasaya yatırmak için yeterli nakit yok!', 'error')
    end
end)

RegisterNetEvent('kibra-emlakv2:server:ChangePassword', function(Password)
    local dosya = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local veri = {}
    veri = json.decode(dosya)
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local information = {EmlakPassword = Password, EmlakName = veri.EmlakName, EmlakPara = veri.EmlakPara}
    SaveResourceFile(GetCurrentResourceName(), "EmlakData.json", json.encode(information), -1)
    TriggerClientEvent('QBCore:Notify', source, 'Kasa şifresi değiştirildi!', 'success')
end)

RegisterNetEvent('kibra-emlakv2:server:EmlakParaCek', function(KacPara)
    local Player = QBCore.Functions.GetPlayer(source)
    local dosya = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local veri = {}
    veri = json.decode(dosya)
    local Total = (veri.EmlakPara-KacPara)
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local information = {EmlakPara = Total, EmlakPassword = veri.EmlakPassword, EmlakName = veri.EmlakName}
    if tonumber(veri.EmlakPara) >= tonumber(KacPara) then
        Player.Functions.AddMoney('cash', KacPara)
        SaveResourceFile(GetCurrentResourceName(), "EmlakData.json", json.encode(information), -1)
        TriggerClientEvent('QBCore:Notify', source, 'Kasaya $'..KacPara..' miktarında para çektiniz!', 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Kasada yeterli para yok!', 'error')
    end
end)

RegisterNetEvent('kibra-emlakv2:server:OpenEmlakManagamentMenu', function()
    local dosya = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local veri = {}
    veri = json.decode(dosya)
    TriggerClientEvent('kibra-emlakv2:client:OpenEmlakMenu', source, veri)
end)

RegisterNetEvent('kibra-emlakv2:server:EmlakNameChange', function(EmlakName)
    local dosya = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local veri = {}
    veri = json.decode(dosya)
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./EmlakData.json")
    local information = {EmlakPassword = veri.EmlakPassword, EmlakName = EmlakName, EmlakPara = veri.EmlakPara}
    SaveResourceFile(GetCurrentResourceName(), "EmlakData.json", json.encode(information), -1)
end)

RegisterNetEvent('kibra-emlakv2:server:DoorLock', function(DoorId, State)
    TriggerClientEvent('kibra-emlakv2:client:DoorLockOpen', -1, DoorId, State)
    KIBRA.EmlakDoorLock[DoorId].DoorLock = State
    if State == not DoorLock then
        TriggerClientEvent('QBCore:Notify', source, 'Kapıyı kilitlediniz', 'error')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Kapı kilidini açtınız', 'success')
    end
end)
