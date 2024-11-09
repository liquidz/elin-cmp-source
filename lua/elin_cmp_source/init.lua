local cmp = require('cmp')

local source = {}

source.new = function()
    local self = setmetatable({}, { __index = source })
    return self
end

function source:is_available()
    if vim.fn['elin#server#is_connected']() then
        return true
    else
        return false
    end
end

function source:get_keyword_pattern()
    return [[\%([0-9a-zA-Z\*\+!\-_'?<>=\/.:]*\)]]
end

function source:get_trigger_characters()
    return {'/', '.', ':'}
end

-- https://github.com/liquidz/elin/blob/4d8ebd007308874276f73884229ed51781c6cf5e/src/elin/handler/complete.clj#L12-L25
local char_to_kind = {
    v = cmp.lsp.CompletionItemKind.Variable,
    f = cmp.lsp.CompletionItemKind.Function,
    k = cmp.lsp.CompletionItemKind.Keyword,
    c = cmp.lsp.CompletionItemKind.Class,
    i = cmp.lsp.CompletionItemKind.Field,
    l = cmp.lsp.CompletionItemKind.Variable,
    m = cmp.lsp.CompletionItemKind.Function,
    n = cmp.lsp.CompletionItemKind.Module,
    r = cmp.lsp.CompletionItemKind.Property,
    s = cmp.lsp.CompletionItemKind.Function,
}

function source:complete(request, callback)
    local input = string.sub(request.context.cursor_before_line, request.offset)
    vim.fn['elin#request_async']('elin.handler.complete/complete', {input}, function(response)
        local items = {}
        for _, candidate in pairs(response) do
            table.insert(items, {
                label = candidate.word,
                kind = char_to_kind[candidate.kind],
                detail = candidate.menu,
                documentation = candidate.info,
            })
        end

        callback(items)
    end)
end

return source
