--great discussion thread about paths (see Thadeu_de_Paula's comment). Will we working this way from now on
function addRelPath(dir)
    local spath = debug.getinfo(1,'S').source:sub(2):gsub("^([^/])","%1"):gsub("[^/]*$","")
    dir = dir and (dir.."/") or ""
    spath = spath..dir
    package.path = spath.."?.lua;"..spath.."?/init.lua"..package.path
end
addRelPath("src/cls")

unit = require("Unit")

local input = 1
u1 = unit.new(1)
    :set("activation_function", "sigmoid")
    :set("bias", 0.4)
    :set("weight", 1)
print(u1:get_output(input))
while(true) do end