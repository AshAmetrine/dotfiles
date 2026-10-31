{
  vim = {
    keymaps = [
      {
        key = "<leader>dl";
        mode = "n";
        action = "vim.diagnostic.setloclist";
        lua = true;
      }
    ];
    lsp = {
      enable = true;
      mappings = {
        goToDeclaration = "gD";
        goToDefinition = "gd";
        addWorkspaceFolder = "<leader>wa";
        removeWorkspaceFolder = "<leader>wr";
        listWorkspaceFolders = "<leader>wl";
        openDiagnosticFloat = "<leader>e";
      };
      lspconfig = {
        enable = true;
      };
      servers = {
        "*" = {
          flags = {
            debounce_text_changes = 250;
          };
        };
        zls.enable = true;
        rust_analyzer.enable = true;
        superhtml.enable = true;
        clangd.enable = true;
        nixd.enable = true;
        ts_ls.enable = true;
        lua_ls.enable = true;
        pylsp = {
          enable = true;
          settings = {
            pylsp = {
              plugins = {
                pylsp_mypy = {
                  enabled = true;
                  live_mode = false;
                  strict = true;
                };
                flake8 = {
                  enabled = false;
                };
                pydocstyle = {
                  enabled = false;
                };
                pylint = {
                  enabled = false;
                };
                rope_completion = {
                  enabled = false;
                };
              };
            };
          };
        };
      };
    };
    diagnostics = {
      enable = true;
      config = {
        virtual_text = true;
      };
    };
  };
}
