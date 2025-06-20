{ config, pkgs, lib, ... }:

{
  home.username = "therare";
  home.homeDirectory = "/home/therare";
  home.stateVersion = "25.05";

  programs.btop.enable = true;
  programs.neovim.enable = true;

  home.packages = with pkgs; [
    telegram-desktop
    htop
    neofetch
    firefox
    openssh
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      c = "clear";
      l = "ls -lh";
      gs = "git status";
      s = "sudo nixos-rebuild switch --flake ~/nixos-config#therare";
    };
  };

  programs.git = {
    enable = true;
    userName = "rarebek";
    userEmail = "nomonovn2@gmail.com";
    signing = {
      signByDefault = true;
      key = "~/.ssh/id_ed25519.pub";
    };
    extraConfig = {
      gpg = {
        format = "ssh";
      };
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };


  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  services.ssh-agent.enable = true;

  home.activation.generateSshKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    keyfile="$HOME/.ssh/id_ed25519"
    if [ ! -f "$keyfile" ]; then
      echo "[+] Generating SSH key for Git signing..."
      mkdir -p "$HOME/.ssh"
      chmod 700 "$HOME/.ssh"
      ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f "$keyfile" -N "" -C "nomonovn2@google.com"
    else
      echo "[=] SSH key already exists, skipping generation"
    fi
  '';


  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = ":minimize,maximize,close";
}
