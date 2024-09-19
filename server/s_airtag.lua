QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("airtag", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent('jaki-airtag:client:useAirtag', source)
    end
end)
