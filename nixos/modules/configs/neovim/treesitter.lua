vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    if not pcall(vim.treesitter.start) then
      return
    end

    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldenable = false
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
