Plugin = {}

local default_config = {
  force_open = false,
  open_cmd = "tabnew",
  binded_handlers = {
    "textDocument/declaration",
    "textDocument/definition",
    "textDocument/typeDefinition",
    "textDocument/implementation",
  },
}

Plugin.config = default_config

Plugin.handler = function(original_handler)
  return function(err, result, ctx, config)
    if
      Plugin.force_open
      or (
        vim.tbl_islist(result)
        and #result >= 1
        and type(result[1].uri) == "string"
        and result[1].uri:gsub("file://", "") ~= vim.fn.expand("%:p")
      )
    then
      vim.api.nvim_command(Plugin.config.open_cmd)
    end
    return original_handler(err, result, ctx, config)
  end
end

Plugin.setup = function(opts)
  if opts == nil then
    opts = {}
  elseif type(opts) ~= "table" then
    return
  end

  for k, v in pairs(opts) do
    if Plugin.config[k] ~= nil then
      Plugin.config[k] = v
    end
  end
  for _, attribute in ipairs(Plugin.config.binded_handlers) do
    vim.lsp.handlers[attribute] = Plugin.handler(vim.lsp.handlers[attribute])
  end
end

return Plugin
