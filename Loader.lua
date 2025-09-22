
local function loadGames()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/hailazra/Public/refs/heads/main/games.lua"))()
    end)
    
    if not success then
        warn("[LOADER] Failed to load games list:", result)
        return nil
    end
    
    return result
end

local function executeScript(url)
    local success, scriptSource = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success or not scriptSource or scriptSource == "" then
        warn("[LOADER] Failed to fetch script from:", url)
        return false
    end
    
    local compiledScript, compileError = loadstring(scriptSource)
    if not compiledScript then
        warn("[LOADER] Script compilation failed:", compileError)
        return false
    end
    
    local executeSuccess, executeError = pcall(compiledScript)
    if not executeSuccess then
        warn("[LOADER] Script execution failed:", executeError)
        return false
    end
    
    return true
end

-- Main execution
local Games = loadGames()
if not Games then
    return
end

-- Convert PlaceId to string for universal compatibility
local currentPlaceId = tostring(game.PlaceId)
local scriptUrl = Games[currentPlaceId]

if not scriptUrl then
    warn("[LOADER] Game not supported. PlaceId:", currentPlaceId)
    -- Optional: Add supported games list
    print("[INFO] Supported games:")
    for placeId, url in pairs(Games) do
        print("  - PlaceId:", placeId)
    end
    return
end

print("[LOADER] Loading script for PlaceId:", currentPlaceId)
if executeScript(scriptUrl) then
    print("[LOADER] Script loaded successfully!")
else
    warn("[LOADER] Failed to load script")
end
