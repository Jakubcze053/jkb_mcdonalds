ESX = nil
ESX = exports['es_extended']:getSharedObject()

local ordersCount = 0
local lastReset = os.date('%Y-%m-%d')

RegisterServerEvent('mcdonalds:processPayment')
AddEventHandler('mcdonalds:processPayment', function(method, amount, basket)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return
    end

    if not basket or type(basket) ~= 'table' or amount <= 0 then
        return
    end

    if method == 'cash' then
        if xPlayer.getMoney() >= amount then
            xPlayer.removeMoney(amount)
        else
            TriggerClientEvent('esx:showNotification', source, GetLocale('insufficient_funds'))
            return
        end
    elseif method == 'card' then
        if xPlayer.getAccount('bank').money >= amount then
            xPlayer.removeAccountMoney('bank', amount)
        else
            TriggerClientEvent('esx:showNotification', source, GetLocale('insufficient_funds_bank'))
            return
        end
    else
        TriggerClientEvent('esx:showNotification', source, GetLocale('invalid_payment'))
        return
    end

    for _, item in ipairs(basket) do
        if item and item.value then
            xPlayer.addInventoryItem(item.value, 1)
        end
    end

    -- Increment order count and send notification with order number
    ordersCount = ordersCount + 1
    local orderNumber = ordersCount
    TriggerClientEvent('esx:showNotification', source, string.format(GetLocale('successful_payment_order'), amount, orderNumber))
end)

-- Automatic reset of orders at a specific time
CreateThread(function()
    while true do
        local currentTime = os.date('*t')
        if currentTime.hour == Config.ResetTime.hour and currentTime.min == Config.ResetTime.minute then
            ordersCount = 0
            lastReset = os.date('%Y-%m-%d')
            print('Objednávky byly resetovány.')
            Wait(60000) -- Prevent multiple resets within the same minute
        end
        Wait(1000) -- Check time every second
    end
end)
