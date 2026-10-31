{ lib, ... }:
let
  raw = lib.generators.mkLuaInline;
  bufferNotEmpty = raw "function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end";
  wideWindow = raw "function() return vim.fn.winwidth(0) > 80 end";
in
{
  vim.statusline.lualine = {
    enable = true;
    setupOpts = {
      sections = {
        lualine_c = [
          {
            "@1" = raw ''
              function()
                return ''
              end
            '';
            color = raw ''
              function()
                -- auto change color according to neovims mode
                local mode_color = {
                  n = "#51afef",
                  i = "#98be65",
                  v = "#a9a1e1",
                  ['\22'] = "#a9a1e1",
                  V = "#a9a1e1",
                  c = "#ECBE7B",
                  no = "#51afef",
                  s = "#FF8800",
                  S = "#FF8800",
                  ['\19'] = "#FF8800",
                  ic = "#ECBE7B",
                  R = "#ec5f67",
                  Rv = "#ec5f67",
                  cv = "#ECBE7B",
                  ce = "#ECBE7B",
                  r = "#008080",
                  rm = "#008080",
                  ['r?'] = "#008080",
                  ['!'] = "#FF8800",
                  t = "#98be65",
                }
                return { fg = mode_color[vim.fn.mode()] }
              end
            '';
            padding = {
              right = 1;
            };
          }
          {
            "@1" = "filesize";
            cond = bufferNotEmpty;
          }
          {
            "@1" = "filename";
            cond = bufferNotEmpty;
            color = {
              gui = "bold";
              fg = "#c678dd";
            };
          }
          {
            "@1" = "location";
          }
          {
            "@1" = "progress";
            color = {
              gui = "bold";
              fg = "#bbc2cf";
            };
          }
          {
            "@1" = "diagnostics";
            diagnostics_color = {
              color_info = {
                fg = "#008080";
              };
              color_error = {
                fg = "#ec5f67";
              };
              color_warn = {
                fg = "#ECBE7B";
              };
            };
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
            };
            sources = [ "nvim_diagnostic" ];
          }
          {
            "@1" = raw ''
              function()
                return '%='
              end
            '';
          }
          {
            "@1" = raw ''
              function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                return clients[1] and clients[1].name or 'None'
              end
            '';
            icon = " LSP:";
            color = {
              gui = "bold";
              fg = "#ffffff";
            };
          }
        ];
        lualine_x = [
          {
            "@1" = "o:encoding";
            cond = wideWindow;
            fmt = raw "string.upper";
            color = {
              gui = "bold";
              fg = "#98be65";
            };
          }
          {
            "@1" = "fileformat";
            fmt = raw "string.upper";
            icons_enabled = true;
            color = {
              gui = "bold";
              fg = "#98be65";
            };
          }
          {
            "@1" = "branch";
            icon = "";
            color = {
              gui = "bold";
              fg = "#a9a1e1";
            };
          }
          {
            "@1" = "diff";
            symbols = {
              modified = "󰝤 ";
              added = " ";
              removed = " ";
            };
            diff_color = {
              modified = {
                fg = "#FF8800";
              };
              added = {
                fg = "#98be65";
              };
              removed = {
                fg = "#ec5f67";
              };
            };
            cond = wideWindow;
          }
        ];
        lualine_a = [ ];
        lualine_b = [ ];
        lualine_y = [ ];
        lualine_z = [ ];
      };
      options = {
        disabled_filetypes = [ "NvimTree" ];
        always_show_tabline = true;
        component_separators = "";
        section_separators = "";
        theme = "tokyonight-storm";
      };
      inactive_sections = {
        lualine_c = [ ];
        lualine_x = [ ];
        lualine_a = [ ];
        lualine_b = [ ];
        lualine_y = [ ];
        lualine_z = [ ];
      };
      tabline = {
        lualine_c = [ ];
        lualine_x = [ ];
        lualine_a = [
          {
            "@1" = "buffers";
            buffers_color = {
              active = {
                bg = "#292e42";
                fg = "#bbc2cf";
              };
              inactive = {
                bg = "#1f2335";
                fg = "#565f89";
              };
            };
            symbols = {
              modified = " ●";
              alternate_file = "#";
              directory = "";
            };
            show_modified_status = true;
          }
        ];
        lualine_b = [ ];
        lualine_y = [ ];
        lualine_z = [
          {
            "@1" = "tabs";
            show_modified_status = true;
            symbols = {
              modified = " ●";
            };
            tabs_color = {
              active = {
                bg = "#292e42";
                fg = "#bbc2cf";
              };
              inactive = {
                bg = "#1f2335";
                fg = "#565f89";
              };
            };
          }
        ];
      };
      extensions = lib.mkForce [ ];
    };
  };
}
