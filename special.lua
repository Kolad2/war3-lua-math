math.special = math.special or {}
do
    local special = math.special
    
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
end
