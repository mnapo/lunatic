local M = {}
M.dispatcher = require("test_dispatcher")

M.TESTS = {
    documents = {M.dispatcher.run_documents, "Document Parsing"},
    networks = {M.dispatcher.run_networks, "Neuronal Networks"},
    vectorial = {M.dispatcher.run_vectorial, "Vectorial"}
}
M.clock = os.clock
M.registered = {}
M.SEPARATOR = "----------------------------------------------------------------------"
M.TIME_MSG = "~~~~~~~~~~ took %0.6f seconds ~~~~~~~~~~"

M.print_tests_name = function(id)
    print(M.SEPARATOR)
    print(M.TESTS[id][2].." tests")
    print(M.SEPARATOR)
end

M.register = function(key)
    M.registered[#M.registered+1] = key
end

M.register_all = function()
    for test, _ in pairs(M.TESTS) do
        M.register(test)
    end
end

M.run = function(tests_to_run)
    if tests_to_run == "all" or tests_to_run == nil then
        tests_to_run = M.registered
    end
    for i = 1, #tests_to_run do
        local tests_id = tests_to_run[i]
        M.print_tests_name(tests_id)
        local t1 = M.clock()
        M.TESTS[tests_id][1]()
        local t2 = M.clock()
        print(string.format(M.TIME_MSG, t2 - t1))
    end
end

return M