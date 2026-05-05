{ ... }:
{
  flake.nixosModules.zsh =
    { pkgs, ... }:
    let
      myAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ~/flakeparts";
        upgrade = "cd ~/flakeparts && nix flake update && cd && sudo nixos-rebuild switch --flake ~/flakeparts";
        clean-home = "nix-collect-garbage -d";
        clean-system = "sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        connect-contabo-mine = "ssh root@45.159.222.167";
        # biome-init = "npm i -D -E @biomejs/biome && cat $BIOME_CONFIG > biome.json";
        ls = "eza --icons=always";
        cd = "z";
        dev = "tmux new-session \\; split-window -h \\; split-window -v \\; select-pane -t 0";
      };
      # FZF theme
      fg = "#CBE0F0";
      bg = "#011628";
      bg_highlight = "#143652";
      purple = "#B388FF";
      blue = "#06BCE4";
      cyan = "#2CF9ED";
    in
    {
      environment.systemPackages = with pkgs; [
        zoxide
        bat
        eza
        oh-my-posh
        fzf
        fd
        fzf-git-sh
        delta
        tldr
      ];

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases = myAliases;
        interactiveShellInit = ''
          HISTSIZE=10000
          SAVEHIST=10000
          HISTFILE="$HOME/.zsh_history"
          setopt HIST_IGNORE_DUPS
          setopt HIST_IGNORE_SPACE
          setopt SHARE_HISTORY

          # Oh My Posh configuration
          eval "$(oh-my-posh init zsh --config ${./pure.toml})"
          # FZF configuration
          eval "$(fzf --zsh)"
          export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
          # Use fd instead of find
          export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
          export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
          export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
          # Use fd for path completion
          _fzf_compgen_path() {
            fd --hidden --exclude .git . "$1"
          }
          _fzf_compgen_dir() {
            fd --type=d --hidden --exclude .git . "$1"
          }
          # fzf-git-sh
          source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
          # Preview functions
          show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
          export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
          export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
          # FZF completion function
          _fzf_comprun() {
            local command=$1
            shift
            case "$command" in
              cd)           fzf --preview 'eza --tree --color=always \{} | head -200' "$@" ;;
              export|unset) fzf --preview "eval 'echo $\{}'"         "$@" ;;
              ssh)          fzf --preview 'dig \{}'                   "$@" ;;
              *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
            esac
          }
          # Zoxide (better cd)
          eval "$(zoxide init zsh)"
        '';
      };
    };
}
