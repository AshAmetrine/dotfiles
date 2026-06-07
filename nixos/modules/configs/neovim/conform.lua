require("conform").setup({
    formatters_by_ft = {
        lua = {"stylua"},
        nix = {"nixfmt"},
        ["_"] = {"trim_whitespace"}
    },
     --format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
     --if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
     --return
     --end
     --return { timeout_ms = 500, lsp_format = "fallback" }
     --end,
})

-- vim.api.nvim_create_user_command("FormatDisable", function(args)
-- if args.bang then
-- vim.b.disable_autoformat = true
-- else
-- vim.g.disable_autoformat = true
-- end
-- end, {
-- desc = "Disable autoformat-on-save",
-- bang = true,
-- })
-- vim.api.nvim_create_user_command("FormatEnable", function()
-- vim.b.disable_autoformat = false
-- vim.g.disable_autoformat = false
-- end, {
-- desc = "Re-enable autoformat-on-save",
-- })

vim.keymap.set("n", "<space>f", function()
    require("conform").format({
        async = true,
        lsp_format = "fallback",
        timeout_ms = 1000
    })
end, {desc = "Format buffer with conform"})
