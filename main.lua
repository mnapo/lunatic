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
    local vectorial_test = require("vector_operations")
    local and_test = require("and")
    local or_test = require("or")

    vectorial_test.run()
    
    and_test.run{1, 1}
    and_test.run{1, 0}
    and_test.run{0, 1}
    and_test.run{0, 0}

    or_test.run{1, 1}
    or_test.run{1, 0}
    or_test.run{0, 1}
    or_test.run{0, 0}
end