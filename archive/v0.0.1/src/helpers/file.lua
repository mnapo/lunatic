local M = {}

M.read_html_file = function(path)
end
M.read_pdf_file = function(path)
end
M.read_txt_file = function(path)
end
M.get_web_content = function(url)
end

M.get_size = function(source)
    local size = 0
    return size
end
M.get_content = function(source, type)
    local content = ""
    if type == "string" then
        content = source
    elseif type == "html" then
        content = M.read_html_file(source)
    elseif type == "pdf" then
        content = M.read_pdf_file(source)
    elseif type == "txt" then
        content = M.read_txt_file(source)
    elseif type == "web" then
        content = M.get_web_content(source)
    end
    return content
end
M.get_type = function(source)
    local type = ""
    return type
end
M.read = function(source)
    local type = get_type(source)
    local size = get_size(source)
    local content = get_content(source, type)
    return {content=content, type=type, size=size}
end

return M