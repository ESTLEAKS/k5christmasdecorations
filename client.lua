local spawnedProps = {}

-- Function to spawn a prop
local function SpawnProp(propData)
    local propHash = GetHashKey(propData.prop)
    
    RequestModel(propHash)
    while not HasModelLoaded(propHash) do
        Wait(100)
    end
    
    local prop = CreateObject(propHash, propData.coords.x, propData.coords.y, propData.coords.z, false, false, false)
    
    SetEntityHeading(prop, propData.heading)
    FreezeEntityPosition(prop, true)
    SetEntityAsMissionEntity(prop, true, true)
    
    -- Apply scale if specified
    if propData.scale then
        SetObjectScale(prop, propData.scale)
    end
    
    table.insert(spawnedProps, prop)
    
    SetModelAsNoLongerNeeded(propHash)
end

-- Spawn all Legion Square props
Citizen.CreateThread(function()
    Wait(1000) -- Wait for game to load
    
    print("^2[Christmas Props] ^7Spawning Legion Square decorations...")
    
    for _, propData in pairs(Config.LegionSquare) do
        SpawnProp(propData)
    end
    
    print("^2[Christmas Props] ^7Legion Square decorated!")
end)

-- Spawn all map props
Citizen.CreateThread(function()
    Wait(2000) -- Wait a bit longer for map props
    
    print("^2[Christmas Props] ^7Spawning Christmas decorations around the map...")
    
    for _, propData in pairs(Config.ChristmasProps) do
        SpawnProp(propData)
        Wait(50) -- Small delay between spawns to avoid lag
    end
    
    print("^2[Christmas Props] ^7All Christmas decorations spawned! Happy Holidays!")
end)

-- Clean up props on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print("^2[Christmas Props] ^7Removing all decorations...")
        
        for _, prop in pairs(spawnedProps) do
            if DoesEntityExist(prop) then
                DeleteObject(prop)
            end
        end
        
        spawnedProps = {}
        print("^2[Christmas Props] ^7All decorations removed!")
    end
end)
