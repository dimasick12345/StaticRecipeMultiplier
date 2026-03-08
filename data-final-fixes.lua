local multiplier = settings.startup["srm-multiplier"].value
local ignore_str = settings.startup["srm-ignore-items"].value or ""

-- Парсим список ТОЛЬКО если поле не пустое. Если пустое — игнорируем НИЧЕГО (умножаем всё)
local ignored_items = {}
if ignore_str and ignore_str ~= "" then
  for name in string.gmatch(ignore_str, "[^,]+") do
    local trimmed = name:match("^%s*(.-)%s*$")
    if trimmed and trimmed ~= "" then
      trimmed = trimmed:gsub("^factorio:", "")
      ignored_items[trimmed] = true
    end
  end
end

-- Автоматический сбор всех руд/сырьё
local ore_items = {}
for _, resource in pairs(data.raw.resource) do
  if resource.minable then
    local results = resource.minable.results
    if not results and resource.minable.result then
      results = {{name = resource.minable.result}}
    end
    if results then
      for _, res in ipairs(results) do
        if res.name then
          ore_items[res.name] = true
        end
      end
    end
  end
end

local function contains_ore(ingredients)
  if not ingredients then return false end
  for _, ing in ipairs(ingredients) do
    if ing.name and ore_items[ing.name] then
      return true
    end
  end
  return false
end

local function produces_ignored_item(recipe)
  if recipe.result and ignored_items[recipe.result] then return true end
  if recipe.results then
    for _, res in ipairs(recipe.results) do
      if res.name and ignored_items[res.name] then return true end
    end
  end
  return false
end

local function multiply_ingredients(ingredients)
  if not ingredients then return end
  for _, ing in ipairs(ingredients) do
    if ing.amount then
      ing.amount = math.ceil(ing.amount * multiplier)
    end
  end
end

for name, recipe in pairs(data.raw.recipe) do
  if recipe.ingredients 
     and not contains_ore(recipe.ingredients) 
     and not produces_ignored_item(recipe) then
    multiply_ingredients(recipe.ingredients)
  end
end
