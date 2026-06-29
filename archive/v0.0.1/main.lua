do  --great discussion thread about paths (see Thadeu_de_Paula's comment). Will we working this way from now on
    local function addRelPath(dir)
        local spath = debug.getinfo(1,'S').source:sub(2):gsub("^([^/])","%1"):gsub("[^/]*$","")
        dir = dir and (dir.."/") or ""
        spath = spath..dir
        package.path = spath.."?.lua;"..spath.."?/init.lua;"..package.path
    end
    addRelPath("src")
    addRelPath("src/cls")
    addRelPath("src/cls/math")
    addRelPath("src/cls/network")
    addRelPath("src/cls/semantic")
    addRelPath("src/cls")
    addRelPath("src/helpers")
    addRelPath("tests")
end

do --Let's do some testing
    error = require("ErrorsHandler"):new("verbose").intercept
    local tests = require("tests")
    --tests.register("vectorial")
    --tests.register("networks")
    tests.register("documents")
    tests.run()
end