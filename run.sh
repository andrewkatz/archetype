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
sudo pacman -Syu --noconfirm

# Install yay AUR helper if not present
if ! command -v yay &> /dev/null; then
  echo "Installing yay AUR helper..."
  sudo pacman -S --needed git base-devel --noconfirm
  if [[ ! -d "yay" ]]; then
    echo "Cloning yay repository..."
  else
    echo "yay directory already exists, removing it..."
    rm -rf yay
  fi

  git clone https://aur.archlinux.org/yay.git

  cd yay
  echo "building yay.... yaaaaayyyyy"
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  echo "yay is already installed"
fi

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

# NVIDIA setup
echo "Configuring system for NVIDIA graphics card..."
. install-nvidia.sh

# Install gnome specific things to make it like a tiling WM
echo "Installing Gnome extensions..."
. gnome/gnome-extensions.sh
echo "Setting Gnome hotkeys..."
. gnome/gnome-hotkeys.sh
echo "Configuring Gnome..."
. gnome/gnome-settings.sh

# Some programs just run better as flatpaks. Like discord/spotify
echo "Installing flatpaks (like discord and spotify)"
. install-flatpaks.sh

# Configuring GRUB
echo "Configuring GRUB..."
. configure-grub.sh

# Set up dotfiles
echo "Setting up dotfiles..."
. dotfiles-setup.sh

echo "Creating dev directory..."
mkdir -p ~/dev

echo "Setup complete! You may want to reboot your system."
