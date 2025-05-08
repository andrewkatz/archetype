#!/bin/bash

echo "Removing GRUB delay..."
sudo sed -i 's/GRUB_TIMEOUT_STYLE=menu/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
