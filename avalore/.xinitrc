picom &
xset r rate 200 35 &
setxkbmap -option caps:escape

xwallpaper --zoom ./dotfiles/wallpapers/wallheaven-win.png

xrandr \
  --output eDP-1 --mode 1920x1080 --primary \
  --output HDMI-1 --mode 1920x1080 --right-of eDP-1

exec i3;
