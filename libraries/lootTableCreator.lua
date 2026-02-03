local lootTableCreator = {}

lootTableCreator.blocksWithInventories = {
    [block.bookcase] = true,
    [block.chest] = true,
    [block.crate] = true,
    [block.lockedchest] = true,
    [block.safe] = true
}

function lootTableCreator.checkBlockEmpty(blockPosition)
    local block_id = get_block_info(blockPosition.x, blockPosition.y, blockPosition.z).block_id

    if not lootTableCreator.blocksWithInventories[block_id] then
        return false
    end
    return get_block_inventory(blockPosition.x, blockPosition.y, blockPosition.z) < 1
end

function lootTableCreator.createLootTable(lootTableParameters)
    if lootTableParameters.entries == nil then
        return {}
    end

    local rolls = lootTableParameters.rolls
    if rolls == nil or rolls < 1 then
        rolls = 1
    end

    local entries = lootTableParameters.entries
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
        quantity = weightedEntries[fetchNumber].quantity

        if quantity == nil or quantity < 1 then
            quantity = 1
        end

        for i2 = 1, quantity, 1 do
            lootTable[#lootTable+1] = weightedEntries[fetchNumber].item
        end
    end

    return lootTable
end

function lootTableCreator.fillBlockWithLootTable(lootTableParameters, blockPosition)
    local lootTable = lootTableCreator.createLootTable(lootTableParameters)

    if #lootTable > 0 then
        for index, value in ipairs(lootTable) do
            add_block_inventory(blockPosition.x, blockPosition.y, blockPosition.z, value, 1)
        end
    end
end

return lootTableCreator
