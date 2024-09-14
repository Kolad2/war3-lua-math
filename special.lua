math.special = math.special or {}
do
    local special = math.special
    
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
