{ config, pkgs, lib,  ... }:

# TODO: Investigate https://nix-community.github.io/home-manager/options.xhtml

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tizzysaurus";
  home.homeDirectory = "/home/tizzysaurus";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    _1password-gui
    _1password-cli
    bat
    brave
    btop
    delta
    discord
    kdePackages.kate
    immich
    immich-cli
    python314
    speedtest-cli
    spotify
    tailscale
    vscode

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs.git = {
    enable = true;
    extraConfig = {
      core.editor="code --wait";
      core.pager = "delta";
      delta.hyperlinks = true;
      delta.hyperlinks-file-link-format = "vscode://file/{path}:{line}";
      delta.navigate = true;
      delta.side-by-side = true;
      help.autoCorrect = "prompt";
      interactive.diffFIlter = "delta";
      merge.conflictStyle = "diff3";
      pull.rebase = false;
      push.default = "simple";
      push.autoSetupRemote = true;
      rebase.autoSquash = true;
      rerere.enabled = true;
      status.submoduleSummary = true;
      user.name = "Tizzy Saurus";
      user.email = "tizzysaurus@gmail.com";
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      usernamehw.errorlens
      esbenp.prettier-vscode
      ms-python.python
      bbenoist.nix
      dbaeumer.vscode-eslint
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "pretty-ts-errors";
        publisher = "yoavbls";
        version = "0.6.1";
        sha256 = "sha256-LvX21nEjgayNd9q+uXkahmdYwzfWBZOhQaF+clFUUF4=";
      }
      {
        name = "vs-code-prettier-eslint";
        publisher = "rvest";
        version = "6.0.0";
        sha256 = "sha256-PogNeKhIlcGxUKrW5gHvFhNluUelWDGHCdg5K+xGXJY=";
      }
    ];

    #userSettings = {
    #  "editor.tabSize" = 2
    #}
  };

  # https://github.com/nix-community/home-manager/blob/release-25.05/modules/programs/zsh.nix
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      append = true; # APPEND_HISTORY
      extended = true; # EXTENDED_HISTORY
      findNoDups = true; # HIST_FIND_NO_DUPS
      ignoreDups = false; # HIST_IGNORE_DUPS
      ignoreAllDups = false; # HIST_IGNORE_ALL_DUPS

      # ignorePatterns = literalExpression ''[ "rm *" "pkill *" ]'';
      size = 10000; # NB: default is 10k
    };

    initContent = let
      zshConfigEarlyInit = lib.mkOrder 500 ''
        setopt INC_APPEND_HISTORY_TIME
        setopt PROMPT_SUBST
      '';
      zshConfig = lib.mkOrder 1000 ''
        function parse_git_branch() {
            branch=$(git branch --show-current 2> /dev/null)
            if [ -n "$branch" ]; then
                echo " %F{33}($branch)%f"
            fi
        }
        export PROMPT='%(?.%F{green}√.%F{red}X)%f %F{165}%D{%a %d %b}%f %F{165}%D{%H:%M}%f %F{44}%(5~!%-2~/.../%2~!%~)%f %$(parse_git_branch) %# '
        setopt INC_APPEND_HISTORY_TIME
      '';
    in lib.mkMerge [ zshConfigEarlyInit zshConfig ];

    shellAliases = {
      cz = "code ~/.zshrc";
      rs = "source ~/.zshrc";
      rmrfnm = "rm -rf **/node_modules/";

      # git aliases
      ga = "git add";
      "ga." = "git add .";
      gap = "git add -p";
      gau = "git add -u";
      gb = "git branch"; # TODO: Add my better-git-branch script
      gbd = "git branch -D";
      gbl = "git blame -w -C -C -C";
      gc = "git commit";
      gca = "git commit --amend";
      gcaa = "git commit -a --amend";
      gcae = "git commit --allow-empty --no-verify -m 'Trigger Build'";
      gcam = "git commit --amend -m";
      gcl = "git clone";
      gclfd = "git clean -fd";
      gcm = "git commit -m";
      gco = "git checkout";
      gcob = "git checkout -b";
      gcom = "git checkout main && git pull && git fetch";
      gcp = "git cherry-pick";
      gcpa = "git cherry-pick --abort";
      gcpc = "git cherry-pick --continue";
      gd = "git diff";
      gdm = "git diff main";
      gds = "git diff --staged";
      gdsw = "git diff --staged -w";
      gdw = "git diff -w";
      gf = "git fetch";
      gl = "git log";
      glo = "git log --oneline";
      glol = "git log --oneline -L";
      glor = "git log --oneline --revert";
      glou = "git log --oneline @{u}..";
      gm = "git merge";
      gmm = "git merge main";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gpu = "git pull";
      gr = "git restore";
      gra = "git rebase --abort";
      grc = "git rebase --continue";
      grh = "git reset --hard";
      grhh = "git reset --hard HEAD";
      gri = "git rebase -i";
      grim = "git rebase -i main";
      grmc = "git rm --cached";
      grs = "git restore --staged";
      grv = "git remote -v";
      gs = "git show";
      gsh = "git show HEAD";
      gsp = "git stash pop";
      gsw = "git switch";
      gst = "git status";
      gsync = "git stash --all && git fetch upstream main && gcom && git merge upstream/main && gco - && gmm && gsp";
      gwta = "git worktree add";
      gwtr = "git worktree remove";
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tizzysaurus/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
}
