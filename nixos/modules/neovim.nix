{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      packages.myVimPackages = {
        start = with pkgs.vimPlugins; [
          vim-gitgutter
          zen-mode-nvim
          twilight-nvim
          nvim-web-devicons

          lualine-nvim
          nvim-lspconfig
          lsp_signature-nvim
          blink-cmp
          blink-emoji-nvim
          tokyonight-nvim
          nvim-autopairs
          conform-nvim
          toggleterm-nvim
          mini-bufremove

          # Language Support
          (nvim-treesitter.withPlugins (
            plugins: with plugins; [
              nix
              zig
              fish
              typescript
              rust
              lua
              c
              vimdoc
              superhtml
              ziggy
              yaml
            ]
          ))

          #fyler-nvim
          #mini-icons
          nvim-tree-lua
          guess-indent-nvim
          rainbow-delimiters-nvim
        ];

        opt = [ ];
      };
      customRC = ''
        lua << EOF
          require('guess-indent').setup()
          require('rainbow-delimiters.setup').setup()

          ${lib.strings.fileContents ./configs/neovim/config.lua}

          ${lib.strings.fileContents ./configs/neovim/bufremove.lua}

          ${lib.strings.fileContents ./configs/neovim/blinkcmp.lua}

          ${lib.strings.fileContents ./configs/neovim/autopairs.lua}

          ${lib.strings.fileContents ./configs/neovim/lspconfig.lua}

          ${lib.strings.fileContents ./configs/neovim/lualine.lua}

          ${lib.strings.fileContents ./configs/neovim/conform.lua}

          ${lib.strings.fileContents ./configs/neovim/toggleterm.lua}

          ${lib.strings.fileContents ./configs/neovim/nvim-tree.lua}

          ${lib.strings.fileContents ./configs/neovim/treesitter.lua}

          ${lib.strings.fileContents ./configs/neovim/zen.lua}
        EOF
      '';
    };
  };
}
