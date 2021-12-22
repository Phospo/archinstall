#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=pl_PL.UTF-8" >> /etc/locale.conf
echo "KEYMAP=pl
FONT=Lat2-Terminus16
FONT_MAP=8859-2" >> /etc/vconsole.conf
echo "fosfor" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 fosfor.localdomain  fosfor" >> /etc/hosts

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S grub sudo efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-headers avahi gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip bash-completion openssh rsync reflector acpi acpi_call tlp virt-manager qemu qemu-arch-extra dnsmasq openbsd-netcat iptables-nft ipset firewalld nss-mdns os-prober ntfs-3g terminus-font

# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
# systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

useradd -m fos
echo fos:password | chpasswd
usermod -aG libvirt fosfor
usermod -aG wheel fosfor

echo "fosfor ALL=(ALL) ALL" >> /etc/sudoers.d/fosfor


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"



