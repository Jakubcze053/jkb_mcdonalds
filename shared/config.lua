Config = {}

-- Select Language - Výběr jazyka
Config.Language = 'cz' -- Possible values - Možné hodnoty: 'cz', 'sk', 'en', 'de'

-- Coords Drive-thru - Souřadnice drive-thru zóny
Config.DriveThruZones = {
    {
        coords = vector3(-581.5667, -899.0825, 25.7324),
        size = vector3(3.0, 3.0, 2.0),
        rotation = 0,
        debug = false
    }
}

-- Blip Settings - Nastavení blipů
Config.McDonaldsBlips = {
    {
        coords = vector3(-581.5667, -899.0825, 25.7324), -- Example coordinates
        sprite = 106, -- Blip icon (use any ID you prefer)
        color = 1, -- Blip color
        scale = 0.6, -- Blip size
        name = '<FONT FACE="Fire Sans">McDonald\'s' -- Display name
    },
    -- Add more locations as needed - Zde přidejte více lokací
}

-- Items Menu - Položky menu
Config.MenuItems = {
    { label = 'Cheeseburger', value = 'cheeseburger', price = 5 },
    { label = 'Double Cheeseburger', value = 'dcheeseburger', price = 5 },
    { label = 'Tripple Cheeseburger', value = 'tcheeseburger', price = 5 },
    { label = '6 Chicken Nuggets', value = '6pnuggets', price = 4 },
    { label = '10 Chicken Nuggets', value = '10pnuggets', price = 4 },
    { label = '20 Chicken Nuggets', value = '20pnuggets', price = 4 },
    { label = 'BigMack', value = 'bigmac', price = 4 },
    { label = 'McChicken', value = 'mcchicken', price = 4 },
    { label = 'Coca-Cola', value = 'cola', price = 2 },
    { label = 'Fanta', value = 'fanta', price = 2 },
    { label = 'Sprite', value = 'sprite', price = 2 }
}

-- Reset Time for Orders - Čas pro reset objednávek
Config.ResetTime = {
    hour = 0, -- Hodina, kdy dojde k resetu (např. 0 pro půlnoc)
    minute = 0 -- Minuta, kdy dojde k resetu
}
