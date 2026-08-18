{ pkgs, lib, config, osConfig, ... }:

let
  # Machine-specific monitor config
  # Desktop: 180Hz; Laptop: default
  isLaptop = osConfig.networking.hostName == "lenovo-laptop";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
      };

      # Monitors
      monitor = [
        "eDP-1,preferred,auto,1"           # laptop screen
        ",preferred,180Hz,auto"            # desktop / external
      ];

      # Input
      input = {
        kb_layout = "us,de";
        kb_variant = ",T1";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };

      # Keybinds
      bind = [
        "SUPER, Return, exec, ghostty"
        "SUPER, Q, killactive,"
        "SUPER, M, exit,"
        "SUPER, E, exec, thunar"
        "SUPER, Y, exec, ghostty -e yazi"
        "SUPER, V, togglefloating,"
        ", F11, fullscreen,"
      ];

      # Decoration
      decorations = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      # Animations
      animations.enabled = true;
    };

    extraConfig = lib.optionalString isLaptop ''
      # Autostart
      hl.on("hyprland.start", function()
        hl.exec_cmd("waybar")
        hl.exec_cmd("hyprpaper")
        hl.exec_cmd("hypridle")
      end)


      # Lid switch: lock screen when lid closes
      bindl = ", switch:Lid Switch, exec, hyprlock"
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
