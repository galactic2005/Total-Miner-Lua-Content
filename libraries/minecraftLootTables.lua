local minecraftLootTables = {}

minecraftLootTables.blocksWithInventories = {
    [block.bookcase] = true,
    [block.chest] = true,
    [block.crate] = true,
    [block.lockedchest] = true,
    [block.safe] = true
}

function minecraftLootTables.checkBlockEmpty(blockPosition)
    local block_id = get_block_info(blockPosition.x, blockPosition.y, blockPosition.z).block_id

    if not minecraftLootTables.blocksWithInventories[block_id] then
        return false
    end
    return get_block_inventory(blockPosition.x, blockPosition.y, blockPosition.z) < 1
end

function minecraftLootTables.createMinecraftLootTable(lootTableParameters)
    if lootTableParameters.entries == nil then
        return {}
    end

    local rolls = nil
    if type(lootTableParameters.rolls) == "table" then
        rolls = math.random(lootTableParameters.rolls.min, lootTableParameters.rolls.max)
    else
        rolls = lootTableParameters.rolls
    end
    rolls = (rolls and (rolls == nil or rolls < 1)) or 1

    local entries = lootTableParameters.entries
    local typeMode = ""
    local weightedEntries = {}
    local weight = 0

    for i1 = 1, #entries, 1 do
        weight = entries[i1].weight
        for i2 = 1, weight, 1 do
            weightedEntries[#weightedEntries+1] = entries[i1] 
        end
    end

    local fetchNumber = 0
    local lootTable = {}

    local quantity = 0

    for i1 = 1, rolls, 1 do
        fetchNumber = math.random(#weightedEntries)
        if weightedEntries[fetchNumber].type == "empty" then
            -- do nothing this roll
        elseif weightedEntries[fetchNumber].type == "item" then
            quantity = weightedEntries[fetchNumber].quantity

            if quantity == nil or quantity < 1 then
                quantity = 1
            end

            for i2 = 1, quantity, 1 do
                lootTable[#lootTable+1] = weightedEntries[fetchNumber].name
            end
        end
    end

    return lootTable
end

function minecraftLootTables.fillBlockWithMinecraftLootTable(lootTableParameters, blockPosition)
    local lootTable = minecraftLootTables.createMinecraftLootTable(lootTableParameters)

    if #lootTable > 0 then
        for index, value in ipairs(lootTable) do
            add_block_inventory(blockPosition.x, blockPosition.y, blockPosition.z, value, 1)
        end
    end
end

return minecraftLootTables
