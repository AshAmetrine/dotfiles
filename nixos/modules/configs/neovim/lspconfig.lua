-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local cfg = { toggle_key='<M-x>', move_cursor_key='<M-k>' }
  require "lsp_signature".on_attach(cfg,bufnr)

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<leader>dl', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
end

--local capabilities = require('cmp_nvim_lsp').default_capabilities()
local capabilities = require('blink.cmp').get_lsp_capabilities()
--capabilities.semanticTokensProvider = nil;

vim.diagnostic.config({
  virtual_text = true,
})

vim.lsp.config('*', {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = { 
    debounce_text_changes = 250,
  }
})

-- Compact server list: each entry can carry its binary name and config.
local servers = {
  { name = "zls" },
  { name = "rust_analyzer", bin = "rust-analyzer" },
  { name = "superhtml" },
  { name = "clangd" },
  { name = "nixd" },
  {
    name = "ts_ls",
    bin  = "typescript-language-server",
    config = { cmd = { "typescript-language-server", "--stdio" } },
  },
  {
    name = "pylsp",
    config = {
      settings = {
        pylsp = {
          plugins = {
            ["pylsp_mypy"] = { enabled = true, live_mode = false, strict = true },
            flake8 = { enabled = false },
            pydocstyle = { enabled = false },
            pylint = { enabled = false },
            rope_completion = { enabled = false },
          },
        },
      },
    },
  },
}

for _, srv in ipairs(servers) do
  -- Only register LSP when executable is available.
  if vim.fn.executable(srv.bin or srv.name) == 1 then
    if srv.config then
      vim.lsp.config(srv.name, srv.config)
    end
    vim.lsp.enable(srv.name)
  end
end
