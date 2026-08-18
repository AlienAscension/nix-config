{ pkgs, lib, config, osConfig, ... }:

let
  # Machine-specific monitor config
  # Desktop: 180Hz; Laptop: default
  isLaptop = osConfig.networking.hostName == "laptop";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = null;       # installed by the NixOS module (flake v0.55.4)
    portalPackage = null; # portal wired up by the NixOS module
    settings = { };       # avoid HM's broken hl.* Lua generation
    extraConfig = builtins.readFile ./hyprland.lua
      + lib.optionalString isLaptop ''

        -- Laptop-only: lock on lid close
        hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("hyprlock"), { locked = true })
      '';
  };

  # Waybar
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "tray" "network" "bluetooth" "pulseaudio" "battery" ];
      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
      };
      clock = {
        format = " {:%H:%M}  {:%d.%m.%Y}";
      };
      network = {
        format-wifi = "{essid} ({signalStrength}%)";
        format-ethernet = "{ipaddr}/{cidr}";
        format-disconnected = "Disconnected";
      };
      bluetooth = {
        format = " {status}";
        format-connected = " {device_name}";
      };
      pulseaudio = {
        format = " {volume}%";
        format-muted = " Muted";
      };
      battery = {
        format = "{_capacity}%";
        format-charging = "{capacity}% ";
      };
    }];
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }
      window#waybar {
        background-color: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
      }
      .modules-left, .modules-center, .modules-right {
        padding: 0 8px;
      }
    '';
  };

  # hyprlock
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = false;
        grace = 0;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = [
        {
          path = "color";
          color = "rgb(30, 30, 46)";
        }
      ];
      input-field = [
        {
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          inner_color = "rgba(205, 214, 244, 0.1)";
          font_color = "rgb(205, 214, 244)";
          fade_timeout = 1000;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # hypridle
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;          # 5 min
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;          # 10 min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ] ++ lib.optional isLaptop {
        timeout = 900;            # 15 min, laptop only
        on-timeout = "systemctl suspend";
      };
    };
  };

  # hyprpaper
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "/home/linus/Pictures/wallpaper.jpg" ];
      wallpaper = [ ", /home/linus/Pictures/wallpaper.jpg" ];
    };
  };

  home.packages = with pkgs; [
    hyprlock
    hypridle
    hyprpaper
  ];
}
