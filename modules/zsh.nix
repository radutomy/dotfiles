{ pkgs, config, ... }:
let
  prompt = ''
    setopt PROMPT_SUBST
    _git_branch() {
      local b=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null | sed 's/^/@/')
      [[ -z $b ]] && return
      local d="" u=""
      { ! git diff-index --quiet HEAD 2>/dev/null || [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; } && d="•"
      local c=$(git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null)
      [[ -n $c ]] && { local behind=''${c%%	*} ahead=''${c##*	}; [[ $ahead -gt 0 ]] && u+=" ↑$ahead"; [[ $behind -gt 0 ]] && u+=" ↓$behind"; }
      echo "$b$d$u "
    }
    PROMPT='%F{green}%~%f %F{yellow}$(_git_branch)%f%F{white}❱%f '
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
      ];
      initContent = ''
        # Auto-start tmux session if not already inside tmux
        if [[ -z "$TMUX" && $- == *i* ]]; then
          sh ~/.config/tmux/session.sh
        fi

        ${prompt}
        ${zoxideFallback}
        chpwd() { lsd -F }
        bindkey '^E' clear-screen
      '';
    };
  };
}
