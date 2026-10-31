{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./lualine.nix
    ./lsp.nix
  ];
  vim = {
    appname = "nvim";
    preventJunkFiles = false;
    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };
    options = {
      clipboard = "unnamedplus";
      completeopt = [
        "menuone"
        "noselect"
      ];
      cursorline = true;
      cursorlineopt = "both";
      diffopt = "vertical";
      foldenable = false;
      ignorecase = true;
      laststatus = 3;
      lazyredraw = true;
      linebreak = true;
      list = true;
      listchars.tab = "|·";
      scrolloff = 5;
      shiftround = true;
      shiftwidth = 4;
      smartcase = true;
      smartindent = true;
      splitright = true;
      tabstop = 4;
      undofile = true;
      updatetime = 100;
      backupdir = lib.generators.mkLuaInline "{ vim.fn.stdpath('state') .. '/backup//' }";
      undodir = lib.generators.mkLuaInline "{ vim.fn.stdpath('state') .. '/undo//' }";
      directory = lib.generators.mkLuaInline "{ vim.fn.stdpath('state') .. '/swap//' }";

    };
    keymaps = [
      {
        key = "<C-n>";
        mode = "t";
        action = "<Cmd>NvimTreeToggle<CR>";
      }
      {
        action = "function() require('mini.bufremove').delete(0, false) end";
        key = "<leader>q";
        mode = "n";
        desc = "Delete buffer";
        lua = true;
      }
      {
        action = "function() require('mini.bufremove').delete(0, true) end";
        key = "<leader>Q";
        mode = "n";
        desc = "Force delete buffer";
        lua = true;
      }
      {
        action = "<C-\\><C-n>";
        key = "<C-g>";
        mode = "t";
      }
      {
        action = ":noh<CR><CR>";
        key = "<CR>";
        mode = "n";
        silent = true;
      }
      {
        action = ":";
        key = ";";
        mode = "";
        silent = false;
      }
      {
        action = "function() require('conform').format({ async = true, lsp_format = 'fallback', timeout_ms = 1000 }) end";
        key = "<leader>f";
        mode = "n";
        desc = "Format buffer with conform";
        lua = true;
      }
      {
        action = "<Cmd>ZenMode<CR>";
        key = "<leader>g";
        mode = "n";
        desc = "Toggle Zen Mode";
      }
    ]
    ++
      lib.concatMap
        (key: [
          {
            mode = "t";
            key = "<C-${key}>";
            action = ''<C-\><C-n><C-w>${key}'';
          }
          {
            mode = "";
            key = "<C-${key}>";
            action = "<C-W>${key}";
          }
        ])
        [
          "h"
          "j"
          "k"
          "l"
        ];
    autocmds = [
      {
        event = [ "VimResized" ];
        command = "wincmd =";
      }
      {
        event = [ "VimEnter" ];
        callback = lib.generators.mkLuaInline ''
          function(data)
            local directory = vim.fn.isdirectory(data.file) == 1
            local unnamed = data.file == "" and vim.bo[data.buf].buftype == ""
            if not (directory or unnamed) then
              return
            end
            if directory then
              vim.cmd.enew()
              vim.cmd.bw(data.buf)
              vim.cmd.cd(data.file)
            end
            vim.cmd.NvimTreeOpen()
          end
        '';
      }
      {
        command = "setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2";
        event = [ "FileType" ];
        pattern = [
          "nix"
          "javascript"
          "typescript"
          "json"
          "jsonc"
          "html"
          "css"
          "markdown"
        ];
      }
    ];
    theme = {
      enable = true;
      name = "tokyonight";
      style = "storm";
    };
    highlight = {
      NvimTreeGitDirty.fg = "#f7768e";
      NvimTreeWinSeparator = {
        fg = "#1f2335";
        bg = "NONE";
      };
    };
    treesitter = {
      enable = true;
      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        nix
        zig
        fish
        typescript
        rust
        lua
        c
        vimdoc
        wit
        superhtml
        ziggy
        yaml
      ];
      fold = true;
      indent.pattern = [
        "nix"
        "zig"
        "fish"
        "typescript"
        "rust"
        "lua"
        "c"
        "help"
        "superhtml"
        "ziggy"
        "yaml"
      ];
    };
    autopairs.nvim-autopairs = {
      enable = true;
      setupOpts.check_ts = true;
    };
    lazy.plugins.nvim-autopairs.after = ''
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      -- Custom Rules
      npairs.add_rules {
          Rule(' ', ' '):with_pair(function(opts)
              local pair = opts.line:sub(opts.col - 1, opts.col)
              return vim.tbl_contains({'()', '[]', '{}'}, pair)
          end), Rule('( ', ' )'):with_pair(function() return false end):with_move(
              function(opts) return opts.prev_char:match('.%)') ~= nil end):use_key(
              ')'),
          Rule('{ ', ' }'):with_pair(function() return false end):with_move(
              function(opts) return opts.prev_char:match('.%}') ~= nil end):use_key(
              '}'), Rule('[ ', ' ]'):with_pair(function() return false end):with_move(
              function(opts) return opts.prev_char:match('.%]') ~= nil end):use_key(
              ']')
      }
    '';
    startPlugins = with pkgs.vimPlugins; [
      vim-gitgutter
      limelight-vim
    ];
    lazy.plugins."zen-mode.nvim" = {
      package = pkgs.vimPlugins.zen-mode-nvim;
      setupModule = "zen-mode";
      cmd = [ "ZenMode" ];
      setupOpts = {
        window.options = {
          number = true;
          relativenumber = true;
          cursorlineopt = "line";
        };
        plugins.options = {
          laststatus = 0;
          showtabline = 0;
        };
        plugins.twilight.enabled = false;
        on_open = lib.generators.mkLuaInline "function() vim.cmd.Limelight() end";
        on_close = lib.generators.mkLuaInline "function() vim.cmd('Limelight!') end";
      };
    };
    visuals = {
      nvim-web-devicons.enable = true;
      rainbow-delimiters.enable = true;
    };
    mini.bufremove = {
      enable = true;
      setupOpts.silent = true;
    };
    autocomplete.blink-cmp = {
      enable = true;
      mappings = {
        complete = null;
        confirm = null;
        next = null;
        previous = null;
        close = null;
        scrollDocsUp = null;
        scrollDocsDown = null;
      };
      sourcePlugins.emoji = {
        enable = true;
        package = pkgs.vimPlugins.blink-emoji-nvim;
      };
      setupOpts = {
        completion.documentation.auto_show = false;
        signature.enabled = true;
        keymap.preset = "default";
        sources = {
          default = lib.mkForce [
            "lsp"
            "path"
            "buffer"
            "emoji"
          ];
          providers.emoji = {
            module = "blink-emoji";
            score_offset = 15;
          };
        };
      };
    };
    formatter.conform-nvim = {
      enable = true;
      setupOpts.formatters_by_ft = {
        _ = [ "trim_whitespace" ];
        lua = [ "stylua" ];
        nix = [ "nixfmt" ];
        zig = [ "zigfmt" ];
      };
    };
    filetree.nvimTree = {
      enable = true;
      openOnSetup = false;
      mappings = {
        toggle = "<C-n>";
        refresh = "<leader>r";
        findFile = "<leader>n";
      };
      setupOpts = {
        disable_netrw = true;
        actions.open_file.resize_window = true;
        filters = {
          custom = [ "node_modules" ];
          dotfiles = true;
        };
        renderer = {
          highlight_git = true;
          highlight_opened_files = "icon";
        };
        sync_root_with_cwd = true;
      };
    };
  };
}
