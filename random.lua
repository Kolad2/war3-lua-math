do
    local uniform = (type(math.random) == "function") and math.random or math.uniform
    local random = {
      uniform = uniform,
      poisson = {}
    }
    setmetatable(random, {__call = function(tbl,...) return random.uniform(...) end})
    math.random = random
end


do
    local poisson = math.random.poisson
    local loggamma = math.special.loggamma
  
    function poisson.ptrs(lam)
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
    setmetatable(poisson, {
      __call = function(tbl,lambda,...)
          return poisson.ptrs(lambda)
      end
    })
end
