local args = {...}
local folder = args[1]
-- list all files in the folder
fs.delete("output")
fs.copy(folder,"output")

local folder = "output"

local function split(str)
    local elements = {}
    for word in string.gmatch(str, '([^_]+)') do
        table.insert(elements, word)
    end
    return elements
end

local function swapAndAdd(x,y)
  x = x + 1
  y = y + 1
  return y .. "_" .. x
end

local files, err = fs.list(folder)
if not files then error(err) end
-- scan for width and height
local totalX = 0
local totalY = 0
for i,o in pairs(files) do
    local elements = split(o)
    local currentX = tonumber(elements[1])
    local currentY = tonumber(elements[2])
    if currentX > totalX then
        totalX = currentX
    end
    if currentY > totalY then
        totalY = currentY
    end
end

local elementsNeeded = {}

for i=1,totalX do
    for j=1,totalY  do
        elementsNeeded[swapAndAdd(i,j)] = true
    end
end

for i,o in pairs(files) do
    local elements = split(o)

    local newname = swapAndAdd(elements[1],elements[2]) .. ".png"
    fs.move(fs.combine(folder,o), fs.combine(folder,newname))
    elementsNeeded[swapAndAdd(elements[1],elements[2])] = false
end

for i,o in pairs(elementsNeeded) do
    if o then
        fs.copy("black-1024.png", fs.combine(folder, i .. ".png"))
    end
end

print("Total X: " .. totalX)
print("Total Y: " .. totalY)
