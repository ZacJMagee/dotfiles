{
  description = "Minimal Home manager setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    homeConfigurations.jose = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit inputs system;
      };

      modules = [
        {
          # Your existing Home Manager config...

          home.username = "jose";
          home.homeDirectory = "/home/jose";
          home.stateVersion = "24.11";

          programs.home-manager.enable = true;

          programs.direnv = {
            enableZshIntegration = true;
            enable = true;
          };

          home.sessionPath = [];
          # home.sessionVariables = {
          #   NPM_PACKAGES = "$HOME/.npm-packages";
          #   NODE_PATH = "$HOME/.npm-packages/lib/node_modules";
          #   PATH = "$HOME/.npm-packages/bin:$PATH";
          # };

          home.packages = [
            # Terminal + CLI tools
            pkgs.vim
            pkgs.neovim
            pkgs.kitty
            pkgs.git
            pkgs.tmux
            pkgs.zsh
            pkgs.zoxide
            pkgs.ripgrep
            pkgs.fzf
            pkgs.tree
            pkgs.eza
            pkgs.fd
            pkgs.zsh-autosuggestions
            pkgs.lazygit
            pkgs.kitty-themes
            pkgs.git-lfs
            pkgs.rclone

            # LSP / Dev tools
            pkgs.alejandra
            pkgs.nixd
            pkgs.stylua
            pkgs.isort
            pkgs.prettierd
            pkgs.black
            pkgs.marksman
            pkgs.nodejs_20

            pkgs.lua-language-server
            pkgs.pyright
            pkgs.gcc
            pkgs.qtscrcpy
            pkgs.scrcpy
            pkgs.docker
            pkgs.docker-compose
            pkgs.nerd-fonts.jetbrains-mono # Example: JetBrainsMono Nerd Font
            pkgs.nerd-fonts.fira-code
            pkgs.papirus-icon-theme

            pkgs.vlc
            pkgs.ffmpeg
            pkgs.imagemagick
            pkgs.dive

            # Languages
            pkgs.python311
            pkgs.go
            pkgs.sqlite
            pkgs.python312Packages.debugpy
            pkgs.vscode-langservers-extracted
            pkgs.yaml-language-server
          ];

          programs.zsh = {
            enable = true;
            enableCompletion = true;

            oh-my-zsh = {
              enable = true;
              plugins = ["zoxide" "vi-mode" "fzf"];
            };

            plugins = [
              {
                name = "zsh-syntax-highlighting";
                src = pkgs.fetchFromGitHub {
                  owner = "zsh-users";
                  repo = "zsh-syntax-highlighting";
                  rev = "0.7.1";
                  sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
                };
              }
              {
                name = "zsh-autosuggestions";
                src = pkgs.fetchFromGitHub {
                  owner = "zsh-users";
                  repo = "zsh-autosuggestions";
                  rev = "v0.7.0";
                  sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
                };
              }
              {
                name = "zsh-abbr";
                src = pkgs.zsh-abbr.src;
              }
              {
                name = "zsh-fzf-tab";
                src = pkgs.zsh-fzf-tab.src;
              }
              {
                name = "zsh-completions";
                src = pkgs.zsh-completions.src;
              }
              {
                name = "zsh-you-should-use";
                src = pkgs.zsh-you-should-use.src;
              }
              {
                name = "zsh-fzf-history-search";
                src = pkgs.zsh-fzf-history-search.src;
              }
              {
                name = "zsh-fast-syntax-highlighting";
                src = pkgs.zsh-fast-syntax-highlighting.src;
              }
            ];

            shellAliases = {
              ".." = "cd ..";
              "..." = "cd ../..";
              "...." = "cd ../../..";
              "....." = "cd ../../../..";
              zen = "flatpak run app.zen_browser.zen";
              tree = "tree -a -I '.git|__pycache__|*.pyc|.local|pip|lib|site-packages|target|Cargo.lock|node_modules|.next|yarn.lock|package-lock.json|*.log|.env*|.venv|.direnv' --charset X";
              v = "nvim .";
              nvc = "cd ~/.config/nvim/ && nvim .";
              nixp = "cd ~/.config/nixpkgs/ && nvim .";
              noc = "cd /etc/nixos/ && nvim .";
              ls = "eza -l --icons --color=always --no-filesize --no-user";
              ll = "eza -l --icons --color=always --no-filesize --no-user";
            };

            initContent = ''
              source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
              source ${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh
              source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
              # Source personal secrets if present
                if [ -f "$HOME/.secrets.zsh" ]; then
                source "$HOME/.secrets.zsh"
                fi

                  if command -v tmux >/dev/null 2>&1; then
                    if [ -z "$TMUX" ] && [ -n "$DISPLAY" ] && [ -z "$SSH_CONNECTION" ]; then
                      exec tmux
                    fi
                  fi
            '';
          };

          # services.tailscale.enable = true;
          #
          programs.kitty = {
            enable = true;

            font = {
              name = "Victor Mono Medium"; # Set your font here
              size = 11;
            };
            themeFile = "selenized-black"; # Set your theme here

            settings = {
              font_quality = "subpixel-antialiased";
              scrollback_lines = 10000;
              enable_audio_bell = false;
              confirm_os_window_close = 0;
              allow_remote_control = true;
              listen_on = "unix:/tmp/kitty"; # Needed for `kitty --reload-instances`
              repaint_delay = 8;
              input_delay = 3;
              sync_to_monitor = true;
              tab_bar_edge = "top";
              tab_bar_style = "powerline";
              window_padding_width = 2;
              background_opacity = "0.95";
              placement_strategy = "center";
              shell_integration = "no-cursor"; # Optional: smoother shell startup
            };
          };

          programs.starship.enable = true;

          programs.zoxide = {
            enable = true;
            enableZshIntegration = true;
          };
        }
      ];
    };
  };
}
