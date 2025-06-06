# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
echo "setting wallpaper to ${SCRIPT_DIR}/wallpaper.jpg"
gsettings set org.gnome.desktop.background picture-uri-dark "file://${SCRIPT_DIR}/wallpaper.jpg"
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
gsettings set org.gnome.desktop.peripherals.keyboard delay 250

echo "setting up auto-scale"
cp ${SCRIPT_DIR}/set-scale.desktop ~/.config/autostart/
