{ ... }:
{
  programs.nvf = {
    enable = true;
    defaultEditor = true;
    settings = {
      imports = [ ./configs/neovim ];
    };
  };
}
