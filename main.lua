do  --great discussion thread about paths (see Thadeu_de_Paula's comment). Will we working this way from now on
    function addRelPath(dir)
        local spath = debug.getinfo(1,'S').source:sub(2):gsub("^([^/])","%1"):gsub("[^/]*$","")
        dir = dir and (dir.."/") or ""
        spath = spath..dir
        package.path = spath.."?.lua;"..spath.."?/init.lua;"..package.path
    end
    addRelPath("src/cls")
    addRelPath("src/helpers")
    addRelPath("src/tests")
end

do --Let's do some testing
    local tests = require("tests")
    tests.register("networks")
    tests.register("vectorial")
    tests.run()
end

while true do end