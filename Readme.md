# Раширенная библитека матиматики

Данная библитека math расширяет возможности текущей версии одноименной библеотеки в Warcraft 3 reforged.
Расширение на даный момент добавляет два модуля
math.special и math.random. Предупреждение: math.random теперь таблица, но она может использоваться как функция,
так как на нее установленна метатаблица равномерного распределения.

# Модуль special
## Краткое описание модуля
Модуль реализует некоторые специальные функции 
- факториал
- гамма функция
- логарифм гамма функции
- функция ошибок
- бетта функция

## Текущий программный интерфейс (API) модуля special
```lua
do
    local special = math.special
    function special.factorial(n) end
    function special.gamma(x) end
    function special.loggamma(k) end
    function special.erf(x) end
    function special.beta(a, b) end
end 
```

# Модуль random
## Краткое описание модуля

Модуль позволяет генерировать случайные величины следующих распределений
- равномерное (хук из math.random)
- пуссоновское (rewrite реализации c++ под numpy для lua)
- экспоненциальное (метод обратной функции)
- нормальное (метод Бокса-Мюллера)

## Текущий программный интерфейс (API) модуля random

```lua
do
    -- Хук для равномерного распределения
    local uniform = {}
    uniform.rvs = (type(math.random) == "function") and math.random or math.uniform.rvs
    -- Опредедение модулей
    local random = {
        uniform = uniform,
        poisson = {},
        exponential = {},
        normal = {}
    }
    -- Установка метатаблицы для math.random как random.uniform.rvs()
    setmetatable(random, {__call = function(tbl,...) return random.uniform.rvs(...) end})
    
    --[[установка метатаблицы для каждого из модfunction math.random.poisson.rvs(lambda) endулей
        как random[distr].rvs()]]--
    local meta_distr = {
        __call = function(distr,...)
            return distr.rvs(...)
        end
    }
    for key, val in pairs(random) do
        setmetatable(val, meta_distr)
    end
    
    math.random = random
end 

-- хук из старого math.random
function math.random.uniform.rvs(i, j) end
function math.random.poisson.rvs(lambda) end
function math.random.exponential.rvs(lambda) end
function math.random.normal.rvs(mean, std) end
```
# Источники
## Использованные источники
- [[1]](https://hpaulkeeler.com/simulating-poisson-random-variables-survey-methods/) - статья
  про то какие бывают алгоритмы пуассоновского распределения и какие используются в какой мат. системе.

## Полезные источники
- lua-set https://github.com/wscherphof/lua-set/tree/master
- [LuaSortingAlgorithms](https://github.com/DervexDev/LuaSortingAlgorithms) -
  репозиторий конвертированных из python алгоритмов сортировки.
- [cheapack](https://github.com/nazarpunk/cheapack) -
  совсем не дешевый упаковщик *.lua файлов в *.wct файл Warcraft 3.
- [imp-lua-mm](https://github.com/Indaxia/imp-lua-mm)
- [luaforwindows](https://github.com/rjpcomputing/luaforwindows) -
  репозиторий хранящий Lua.exe файл для windows
- [lua-table](https://github.com/Luca96/lua-table/tree/master) - база функций расширяющих стандартный набор
    table c добавлением дополнительных свойств.
- [t-util](https://github.com/loominatrx/t-util/tree/main) - база функций расширяющих стандартный набор.
- [xlua](https://github.com/torch/xlua/tree/master) - база функций расширяющих стандартный набор.
- [table-manual](https://www.lua.org/manual/5.4/manual.html#6.6) - официальный мануал по таблицам
