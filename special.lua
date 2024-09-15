math.special = math.special or {}
do
    local special = math.special

    function special.factorial(n)
        if n % 1 ~= 0 then return nil end
        if n == 0 or n == 1 then return 1 end
        return n*factorial(n-1)  
    end
    
    -- используем приближение Ланцоша
    function special.gamma(x)
        local g = 7
        local p = {
            0.99999999999980993,
            676.5203681218851,
           -1259.1392167224028,
            771.32342877765313,
           -176.61502916214059,
            12.507343278686905,
           -0.13857109526572012,
            9.9843695780195716e-6,
            1.5056327351493116e-7
        }
    
        if x < 0.5 then
            -- Формула дополнения
            return math.pi / (math.sin(math.pi * x) * special.gamma(1 - x))
        else
            x = x - 1
            local a = p[1]
            for i = 2, #p do
                a = a + p[i] / (x + i - 1)
            end
            local t = x + g + 0.5
            return math.sqrt(2 * math.pi) * t^(x + 0.5) * math.exp(-t) * a
        end
    end
    
        
   -- Функция для вычисления логарифма гамма-функции
    function special.loggamma(k)
        -- Для целых значений k используем приближение Стирлинга
        if k < 8 then
            -- Прямое вычисление для небольших k
            local res = 0
            for i = 2, k do
                res = res + math.log(i)
            end
            return res
        else
            -- Приближение Стирлинга
            local k_float = k
            local term1 = (k_float + 0.5) * math.log(k_float)
            local term2 = -k_float + 0.5 * math.log(2 * math.pi)
            local term3 = 1 / (12 * k_float)
            return term1 + term2 + term3
        end
    end
    
        -- Функция erf(x)
    function special.erf(x)
        -- Константы
        local a1 =  0.254829592
        local a2 = -0.284496736
        local a3 =  1.421413741
        local a4 = -1.453152027
        local a5 =  1.061405429
        local p  =  0.3275911
    
        -- Сохранение знака x
        local sign = 1
        if x < 0 then
            sign = -1
        end
        x = math.abs(x)
    
        -- Вычисление по формуле
        local t = 1.0 / (1.0 + p * x)
        local y = 1.0 - (((((a5 * t + a4) * t + a3) * t + a2) * t + a1) * t) * math.exp(-x * x)
    
        return sign * y
    end

    
    -- Функция beta(a, b)
    function special.beta(a, b)
        return math.exp(special.loggamma(a) + special.loggamma(b) - special.loggamma(a + b))
    end
    
end
