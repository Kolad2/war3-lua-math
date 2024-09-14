do
    local random = {
        uniform = math.random
    }



    setmetatable(random, {__call = random.uniform})
    math.random = random
end