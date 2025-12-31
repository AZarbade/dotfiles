picom &
xset r rate 200 35 &
setxkbmap -option caps:escape

xwallpaper --zoom ./dotfiles/wallpapers/wallhaven-building.png

# Automatically detect connected monitors and configure them
for output in $(xrandr | grep " connected" | cut -d" " -f1); do
    if [[ $output != "eDP-1" ]]; then
        xrandr --output $output --auto --right-of eDP-1
    fi
done

# Set the primary monitor to eDP-1 (laptop display)
xrandr --output eDP-1 --primary --auto

exec i3;
