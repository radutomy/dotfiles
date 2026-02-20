{ pkgs, config, ... }:
let
  prompt = ''
    setopt PROMPT_SUBST
    PROMPT='%F{green}%~%f ''${''${GITSTATUS_PROMPT:+''${GITSTATUS_PROMPT//%76F/%244F} }}%F{white}❱%f '
  '';

  zoxideFallback = ''
    zstyle ':fzf-tab:complete:(cd|z):*' disabled-on any
    zstyle ':completion:*:(cd|z):*' menu select
    zstyle ':completion:*' matcher-list "m:{a-z}={A-Z}"

    typeset -ga _zr=(); typeset -gi _zi=0
    _zf() {
      local cmd=''${''${(z)BUFFER}[1]} arg=''${''${(z)BUFFER}[2]}
      if [[ $cmd != (z|cd) || -z $arg ]]; then _zr=(); _zi=0; zle fzf-tab-complete; return; fi
      if (( ''${#_zr} > 1 && _zi > 0 )) && [[ $arg == ''${_zr[$_zi]} ]]; then
        _zi=$(( _zi % ''${#_zr} + 1 ))
        BUFFER="$cmd ''${_zr[$_zi]}"; CURSOR=''${#BUFFER}; zle autosuggest-clear; zle redisplay; return
      fi
      _zr=(); _zi=0
      local -a _ld=(''${arg}*(/N))
      (( ''${#_ld} )) && { zle fzf-tab-complete; return; }
      _zr=("''${(@f)$(zoxide query -l -- $arg 2>/dev/null)}"); _zi=1
      [[ -n ''${_zr[1]} ]] && { BUFFER="$cmd ''${_zr[1]}"; CURSOR=''${#BUFFER}; zle autosuggest-clear; zle redisplay; return; }
      _zr=(); _zi=0; zle fzf-tab-complete
    }
    zle -N _zf && bindkey '^I' _zf
  '';
in
{
  programs = {
    lsd = {
      enable = true;
      enableZshIntegration = false;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      defaultKeymap = "emacs";
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      shellAliases = {
        cd = "z";
        ls = "lsd --group-dirs=first";
        ll = "lsd -lah --group-dirs=first";
        l = "lsd -A --group-dirs=first";
        cat = "bat --style=plain";
        c = "clear";
        p = "python";
        gg = "lazygit";
        tx = "tmux attach 2>/dev/null || tmux";
        np = "ssh naspi";
        nas = "ssh nas";
        nu = "nix flake update --flake ~/.config && nixos-rebuild switch --flake ~/.config#$HOSTNAME --impure";
      };
      plugins = [
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
        {
          name = "zsh-autopair";
          src = pkgs.zsh-autopair;
          file = "share/zsh/zsh-autopair/autopair.zsh";
        }
        {
          name = "gitstatus";
          src = pkgs.gitstatus;
          file = "share/gitstatus/gitstatus.prompt.zsh";
        }
      ];
      initContent = ''
        # Auto-start tmux session if not already inside tmux
        if [[ -z "$TMUX" && $- == *i* ]]; then
          ~/.config/tmux/session.sh
        fi

        ${prompt}
        ${zoxideFallback}
        chpwd() { lsd -F }
        bindkey '^E' clear-screen
        bindkey "''${terminfo[kRIT5]}" forward-word
        bindkey "''${terminfo[kLFT5]}" backward-word
      '';
    };
  };
}
