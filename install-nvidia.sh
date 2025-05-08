#!/bin/bash

NVIDIA_PACKAGES=(
  linux-headers
  nvidia-dkms
  nvidia-settings
  libva
  libva-nvidia-driver-git
)

echo "Installing NVIDIA packages..."
install_packages "${NVIDIA_PACKAGES[@]}"

echo "Updating system settings for NVIDIA graphics card..."
sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
