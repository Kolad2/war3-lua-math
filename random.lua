do -- reqire "math.special"
    local uniform = {}
    uniform.rvs = (type(math.random) == "function") and math.random or math.uniform.rvs
    
    local random = {
      uniform = uniform,
      poisson = {},
      exponential = {},
      normal = {}
    }
    setmetatable(random, {__call = function(tbl,...) return random.uniform.rvs(...) end})
    
    local meta_distr = {
      __call = function(distribution,...)
          return distribution.rvs(...)
      end
    }
  
    for key, val in pairs(random) do
        setmetatable(val, meta_distr)
    end
    
    math.random = random
end


do -- poisson distribution
    local poisson = math.random.poisson
    math.special = math.special or {}


    function poisson.ptrs(lam)
        local loggamma = math.special.loggamma
        local slam = math.sqrt(lam)
        local loglam = math.log(lam)
        local b = 0.931 + 2.53 * slam
        local a = -0.059 + 0.02483 * b
        local invalpha = 1.1239 + 1.1328 / (b - 3.4)
        local vr = 0.9277 - 3.6224 / (b - 2)

        while true do
            local U = math.random() - 0.5
            local V = math.random()
            local us = 0.5 - math.abs(U)
            local k = math.floor((2 * a / us + b) * U + lam + 0.43)
            if (us >= 0.07) and (V <= vr) then
                return k
            end
            if (k < 0) or ((us < 0.013) and (V > us)) then
                -- Переходим к следующей итерации цикла
            else
                local lhs = math.log(V) + math.log(invalpha) - math.log(a / (us * us) + b)
                local rhs = -lam + k * loglam - loggamma(k + 1)
                if lhs <= rhs then
                    return k
                end
            end
        end
    end

    poisson.rvs = function(lambda)
        return poisson.ptrs(lambda)
    end
end

do -- exponential distribution
    local exponential = math.random.exponential

    function exponential.standart(lambda)
        local u = math.random()
        return - math.log(u) * lambda
    end

    exponential.rvs = function(lambda)
        return exponential.standart(lambda)
    end
end


do -- normal distrebution
    local normal = math.random.normal

    function normal.box_muller()
        local u1 = math.random()
        local u2 = math.random()
        return math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
    end

    function normal.rvs(mean, std)
        mean = mean or 0
        std = std or 1
        return normal.box_muller()*std + mean
    end

end


