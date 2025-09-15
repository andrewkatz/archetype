#!/bin/bash

# Print the logo
print_logo() {
    cat << "EOF"
                   __         __
  ____ ___________/ /_  ___  / /___  ______  ___
 / __ `/ ___/ ___/ __ \/ _ \/ __/ / / / __ \/ _ \
/ /_/ / /  / /__/ / / /  __/ /_/ /_/ / /_/ /  __/
\__,_/_/   \___/_/ /_/\___/\__/\__, / .___/\___/
                              /____/_/

EOF
}

# Clear screen and show logo
clear
print_logo

# Exit on any error
set -e

# Source utility functions
source utils.sh

# Source the package list
if [ ! -f "packages.conf" ]; then
  echo "Error: packages.conf not found!"
  exit 1
fi

source packages.conf

echo "Starting full system setup..."

# Update the system first
echo "Updating system..."
sudo apt update -y && sudo apt upgrade -y

# Install packages by category
echo "Installing system utilities..."
install_packages "${SYSTEM_UTILS[@]}"

echo "Installing development tools..."
install_packages "${DEV_TOOLS[@]}"

echo "Installing system maintenance tools..."
install_packages "${MAINTENANCE[@]}"

echo "Installing desktop environment..."
install_packages "${DESKTOP[@]}"

echo "Installing desktop environment..."
install_packages "${OFFICE[@]}"

echo "Installing media packages..."
install_packages "${MEDIA[@]}"

echo "Installing fonts..."
install_packages "${FONTS[@]}"

# Enable services
echo "Configuring services..."
for service in "${SERVICES[@]}"; do
  if ! systemctl is-enabled "$service" &> /dev/null; then
    echo "Enabling $service..."
    sudo systemctl enable "$service"
  else
    echo "$service is already enabled"
  fi
done

# Install gnome specific things to make it like a tiling WM
echo "Installing Gnome extensions..."
. gnome/gnome-extensions.sh
echo "Setting Gnome hotkeys..."
. gnome/gnome-hotkeys.sh
echo "Configuring Gnome..."
. gnome/gnome-settings.sh

echo "Installing mise..."
curl https://mise.run | sh

echo "Installing spotify..."
. install-spotify.sh

echo "Installing brave..."
curl -fsS https://dl.brave.com/install.sh | sh

echo "Installing snaps..."
for snap in "${SNAPS[@]}"; do
  if ! snap list "$snap" &> /dev/null; then
    echo "Installing $snap..."
    sudo snap install "$snap"
  else
    echo "$snap is already installed"
  fi
done

# Configuring GRUB
echo "Configuring GRUB..."
. configure-grub.sh

# Set up dotfiles
echo "Setting up dotfiles..."
. dotfiles-setup.sh

echo "Creating dev directory..."
mkdir -p ~/dev

echo "Setup complete! You may want to reboot your system."
