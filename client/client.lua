-- client.lua

ESX = nil
ESX = exports['es_extended']:getSharedObject()

local basket = {}
local totalPrice = 0

local function refreshMenu()
    local menuOptions = {}

    for _, item in ipairs(Config.MenuItems) do
        table.insert(menuOptions, {
            title = item.label .. " ($" .. item.price .. ")",
            description = GetLocale('menu_description'),
            event = 'mcdonalds:addToBasket',
            args = item
        })
    end

    table.insert(menuOptions, {
        title = GetLocale('basket_title'),
        description = GetLocale('basket_description'),
        event = 'mcdonalds:showBasket',
        args = { basket = basket, totalPrice = totalPrice }
    })

    lib.registerContext({
        id = 'mcdonalds_menu',
        title = GetLocale('menu_title'),
        options = menuOptions
    })

    lib.showContext('mcdonalds_menu')
end

function openDriveThruMenu()
    refreshMenu()
end

AddEventHandler('mcdonalds:addToBasket', function(item)
    table.insert(basket, item)
    totalPrice = totalPrice + item.price
    ESX.ShowNotification(string.format(GetLocale('add_to_basket'), item.label))
    refreshMenu()
end)

AddEventHandler('mcdonalds:showBasket', function(data)
    if #data.basket == 0 then
        ESX.ShowNotification(GetLocale('basket_empty')) -- Zobrazení notifikace, že košík je prázdný
        return -- Ukončení eventu, aby se košík neotevřel
    end
    
    local basketMenu = {
        id = 'basket_menu',
        title = GetLocale('basket_title'),
        options = {}
    }

    for _, item in ipairs(data.basket) do
        table.insert(basketMenu.options, {
            title = item.label .. ' ($' .. item.price .. ')',
            description = GetLocale('basket_description')
        })
    end

    table.insert(basketMenu.options, {
        title = GetLocale('pay_option'),
        description = GetLocale('pay_description'),
        event = 'mcdonalds:pay',
        args = { basket = data.basket, totalPrice = data.totalPrice }
    })

    table.insert(basketMenu.options, {
        title = GetLocale('cancel_order_option'),
        description = GetLocale('cancel_order_description'),
        event = 'mcdonalds:cancelOrder'
    })

    lib.registerContext(basketMenu)
    lib.showContext('basket_menu')
end)

AddEventHandler('mcdonalds:cancelOrder', function()
    basket = {}
    totalPrice = 0
    ESX.ShowNotification(GetLocale('order_cancelled'))
    refreshMenu()
end)

AddEventHandler('mcdonalds:pay', function(data)
    if data.totalPrice == 0 then
        ESX.ShowNotification(GetLocale('basket_empty'))
        return
    end

    local paymentMethod = lib.inputDialog(GetLocale('payment_title'), {
    {
        type = 'select',
        label = GetLocale('payment_label'),
        options = {
            { label = GetLocale('payment_cash'), value = 'cash' },
            { label = GetLocale('payment_bank'), value = 'card' }
        }
    }
})

    if not paymentMethod then
        ESX.ShowNotification(GetLocale('payment_canceled'))
        return
    end

    local method = paymentMethod[1]

    TriggerServerEvent('mcdonalds:processPayment', method, data.totalPrice, data.basket)

    basket = {}
    totalPrice = 0
    ESX.ShowNotification(GetLocale('payment_processing'))
end)


CreateThread(function()
    if not Config.DriveThruZones or #Config.DriveThruZones == 0 then
        print('Config.DriveThruZones neni spravne nastavene!')
        return
    end

    for _, zone in ipairs(Config.DriveThruZones) do
        exports.ox_target:addBoxZone({
            coords = zone.coords,
            size = zone.size,
            rotation = zone.rotation,
            debug = zone.debug,
            options = {
                {
                    name = 'open_mcd_menu',
                    event = 'mcdonalds:openMenu',
                    icon = 'fas fa-hamburger',
                    label = GetLocale('menu_label')
                }
            }
        })
    end
    AddEventHandler('mcdonalds:openMenu', function()
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            openDriveThruMenu()
        else
            ESX.ShowNotification(GetLocale('not_in_vehicle'))
        end
    end)
end)


local function createBlips()
    if not Config.McDonaldsBlips or #Config.McDonaldsBlips == 0 then
        print('Config.McDonaldsBlips není správně nastavené!')
        return
    end

    for _, blipData in ipairs(Config.McDonaldsBlips) do
        local blip = AddBlipForCoord(blipData.coords.x, blipData.coords.y, blipData.coords.z)
        SetBlipSprite(blip, blipData.sprite)
        SetBlipColour(blip, blipData.color)
        SetBlipScale(blip, blipData.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipData.name)
        EndTextCommandSetBlipName(blip)
    end
end

CreateThread(createBlips)