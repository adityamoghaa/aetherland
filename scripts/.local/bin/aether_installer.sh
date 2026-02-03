#!/bin/bash
# ============================================================================
# Archie-Dotfiles Universal Arch Linux Installer
# Author: Aditya Mogha
# Description: Interactive installation script with toggle options
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration Variables
ENCRYPTION_ENABLED=false
LVM_ENABLED=false
SEPARATE_HOME=false
DUAL_BOOT=false
HOSTNAME=""
USERNAME=""
USER_PASSWORD=""
ROOT_PASSWORD=""
TIMEZONE="America/Chicago"
LOCALE="en_US.UTF-8"
KEYMAP="us"

# Disk variables
PRIMARY_DISK=""
SECONDARY_DISK=""
EFI_SIZE="512M"
BOOT_SIZE="1G"
SWAP_SIZE="4G"  # Default, will be adjusted

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

print_header() {
    clear
    echo -e "${CYAN}"
    echo "═══════════════════════════════════════════════════════════════"
    echo "   █████╗ ██████╗  ██████╗██╗  ██╗██╗███████╗"
    echo "  ██╔══██╗██╔══██╗██╔════╝██║  ██║██║██╔════╝"
    echo "  ███████║██████╔╝██║     ███████║██║█████╗  "
    echo "  ██╔══██║██╔══██╗██║     ██╔══██║██║██╔══╝  "
    echo "  ██║  ██║██║  ██║╚██████╗██║  ██║██║███████╗"
    echo "  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚══════╝"
    echo "═══════════════════════════════════════════════════════════════"
    echo -e "  Universal Arch Linux Installer with Dotfiles Integration"
    echo -e "═══════════════════════════════════════════════════════════════${NC}"
    echo
}

print_step() {
    echo -e "\n${BLUE}==>${NC} ${GREEN}$1${NC}\n"
}

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

prompt_yes_no() {
    local prompt="$1"
    local default="${2:-n}"
    
    while true; do
        if [[ "$default" == "y" ]]; then
            read -p "$prompt [Y/n]: " response
            response=${response:-y}
        else
            read -p "$prompt [y/N]: " response
            response=${response:-n}
        fi
        
        case "$response" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

pause() {
    read -p "Press Enter to continue..."
}

# ============================================================================
# SYSTEM CHECKS
# ============================================================================

check_uefi() {
    print_step "Checking boot mode..."
    if [ -d /sys/firmware/efi/efivars ]; then
        print_info "UEFI mode detected ✓"
        return 0
    else
        print_error "BIOS mode detected. This installer requires UEFI."
        exit 1
    fi
}

check_internet() {
    print_step "Checking internet connection..."
    if ping -c 1 archlinux.org &> /dev/null; then
        print_info "Internet connection active ✓"
        return 0
    else
        print_error "No internet connection. Please connect first."
        echo "Run: iwctl"
        echo "Then: station wlan0 connect <SSID>"
        exit 1
    fi
}

sync_time() {
    print_step "Synchronizing system clock..."
    timedatectl set-ntp true
    print_info "Clock synchronized ✓"
}

# ============================================================================
# CONFIGURATION MENU
# ============================================================================

show_configuration_menu() {
    while true; do
        print_header
        echo -e "${CYAN}Configuration Options:${NC}"
        echo "────────────────────────────────────────────────────────"
        echo -e " 1) Hostname: ${GREEN}${HOSTNAME:-[Not Set]}${NC}"
        echo -e " 2) Username: ${GREEN}${USERNAME:-[Not Set]}${NC}"
        echo -e " 3) Timezone: ${GREEN}${TIMEZONE}${NC}"
        echo -e " 4) Locale: ${GREEN}${LOCALE}${NC}"
        echo -e " 5) Keymap: ${GREEN}${KEYMAP}${NC}"
        echo "────────────────────────────────────────────────────────"
        echo -e " 6) Disk Encryption: ${YELLOW}$([ "$ENCRYPTION_ENABLED" = true ] && echo "ENABLED" || echo "DISABLED")${NC}"
        echo -e " 7) LVM (Logical Volume Manager): ${YELLOW}$([ "$LVM_ENABLED" = true ] && echo "ENABLED" || echo "DISABLED")${NC}"
        echo -e " 8) Separate Home Partition: ${YELLOW}$([ "$SEPARATE_HOME" = true ] && echo "YES" || echo "NO")${NC}"
        echo -e " 9) Dual Boot Setup: ${YELLOW}$([ "$DUAL_BOOT" = true ] && echo "YES" || echo "NO")${NC}"
        echo "────────────────────────────────────────────────────────"
        echo -e " ${GREEN}c)${NC} Continue to Disk Selection"
        echo -e " ${RED}q)${NC} Quit"
        echo "────────────────────────────────────────────────────────"
        read -p "Select option: " choice

        case $choice in
            1) read -p "Enter hostname: " HOSTNAME;;
            2) 
                read -p "Enter username: " USERNAME
                read -sp "Enter user password: " USER_PASSWORD
                echo
                read -sp "Confirm user password: " USER_PASSWORD_CONFIRM
                echo
                if [ "$USER_PASSWORD" != "$USER_PASSWORD_CONFIRM" ]; then
                    print_error "Passwords don't match!"
                    pause
                else
                    read -sp "Enter root password: " ROOT_PASSWORD
                    echo
                    read -sp "Confirm root password: " ROOT_PASSWORD_CONFIRM
                    echo
                    if [ "$ROOT_PASSWORD" != "$ROOT_PASSWORD_CONFIRM" ]; then
                        print_error "Root passwords don't match!"
                        pause
                    fi
                fi
                ;;
            3) read -p "Enter timezone (e.g., America/Chicago): " TIMEZONE;;
            4) read -p "Enter locale (e.g., en_US.UTF-8): " LOCALE;;
            5) read -p "Enter keymap (e.g., us): " KEYMAP;;
            6) ENCRYPTION_ENABLED=$([ "$ENCRYPTION_ENABLED" = true ] && echo false || echo true);;
            7) LVM_ENABLED=$([ "$LVM_ENABLED" = true ] && echo false || echo true);;
            8) SEPARATE_HOME=$([ "$SEPARATE_HOME" = true ] && echo false || echo true);;
            9) DUAL_BOOT=$([ "$DUAL_BOOT" = true ] && echo false || echo true);;
            c|C) 
                if [ -z "$HOSTNAME" ] || [ -z "$USERNAME" ] || [ -z "$USER_PASSWORD" ]; then
                    print_error "Please set hostname, username, and passwords!"
                    pause
                else
                    break
                fi
                ;;
            q|Q) exit 0;;
            *) print_error "Invalid option"; pause;;
        esac
    done
}

# ============================================================================
# DISK SELECTION
# ============================================================================

select_disks() {
    print_header
    print_step "Disk Selection"
    
    echo -e "${CYAN}Available Disks:${NC}"
    lsblk -d -o NAME,SIZE,TYPE,MODEL | grep disk
    echo
    
    read -p "Enter primary disk (e.g., nvme0n1, sda): " PRIMARY_DISK
    PRIMARY_DISK="/dev/$PRIMARY_DISK"
    
    if [ ! -b "$PRIMARY_DISK" ]; then
        print_error "Invalid disk: $PRIMARY_DISK"
        exit 1
    fi
    
    print_info "Primary disk: $PRIMARY_DISK"
    
    if [ "$SEPARATE_HOME" = true ]; then
        if prompt_yes_no "Use a separate physical disk for /home?"; then
            read -p "Enter secondary disk (e.g., nvme1n1, sdb): " SECONDARY_DISK
            SECONDARY_DISK="/dev/$SECONDARY_DISK"
            
            if [ ! -b "$SECONDARY_DISK" ]; then
                print_error "Invalid disk: $SECONDARY_DISK"
                exit 1
            fi
            print_info "Secondary disk: $SECONDARY_DISK"
        fi
    fi
    
    # Calculate swap size (RAM + 2GB)
    TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
    SWAP_SIZE="${TOTAL_RAM}G"
    
    print_warning "This will ERASE all data on $PRIMARY_DISK!"
    [ -n "$SECONDARY_DISK" ] && print_warning "This will ERASE all data on $SECONDARY_DISK!"
    
    if ! prompt_yes_no "Continue with installation?"; then
        exit 0
    fi
}

# ============================================================================
# DISK PARTITIONING
# ============================================================================

partition_disk() {
    print_step "Partitioning $PRIMARY_DISK..."
    
    # Wipe disk signatures
    wipefs -af "$PRIMARY_DISK"
    
    # Create GPT partition table
    parted -s "$PRIMARY_DISK" mklabel gpt
    
    # Create partitions
    parted -s "$PRIMARY_DISK" mkpart "EFI" fat32 1MiB 513MiB
    parted -s "$PRIMARY_DISK" set 1 esp on
    
    parted -s "$PRIMARY_DISK" mkpart "BOOT" ext4 513MiB 1537MiB
    
    if [ "$LVM_ENABLED" = true ]; then
        parted -s "$PRIMARY_DISK" mkpart "LVM" 1537MiB 100%
        parted -s "$PRIMARY_DISK" set 3 lvm on
    else
        # Create root partition
        if [ "$SEPARATE_HOME" = true ] && [ -z "$SECONDARY_DISK" ]; then
            # Root + Home on same disk
            parted -s "$PRIMARY_DISK" mkpart "ROOT" ext4 1537MiB 50%
            parted -s "$PRIMARY_DISK" mkpart "HOME" ext4 50% 100%
        else
            # Just root
            parted -s "$PRIMARY_DISK" mkpart "ROOT" ext4 1537MiB 100%
        fi
    fi
    
    # Partition secondary disk if exists
    if [ -n "$SECONDARY_DISK" ]; then
        wipefs -af "$SECONDARY_DISK"
        parted -s "$SECONDARY_DISK" mklabel gpt
        parted -s "$SECONDARY_DISK" mkpart "HOME" ext4 1MiB 100%
    fi
    
    # Refresh partition table
    partprobe "$PRIMARY_DISK"
    [ -n "$SECONDARY_DISK" ] && partprobe "$SECONDARY_DISK"
    sleep 2
    
    print_info "Partitioning complete ✓"
    lsblk "$PRIMARY_DISK"
}

# ============================================================================
# ENCRYPTION SETUP
# ============================================================================

setup_encryption() {
    if [ "$ENCRYPTION_ENABLED" = false ]; then
        return
    fi
    
    print_step "Setting up disk encryption..."
    
    modprobe dm-crypt
    modprobe dm-mod
    
    local root_part="${PRIMARY_DISK}p3"
    [ ! -b "$root_part" ] && root_part="${PRIMARY_DISK}3"
    
    print_info "Encrypting $root_part..."
    echo -n "$USER_PASSWORD" | cryptsetup luksFormat -v -s 512 -h sha512 "$root_part" -
    echo -n "$USER_PASSWORD" | cryptsetup open "$root_part" luks_lvm -
    
    if [ -n "$SECONDARY_DISK" ]; then
        local home_part="${SECONDARY_DISK}p1"
        [ ! -b "$home_part" ] && home_part="${SECONDARY_DISK}1"
        
        print_info "Encrypting $home_part..."
        echo -n "$USER_PASSWORD" | cryptsetup luksFormat -v -s 512 -h sha512 "$home_part" -
        echo -n "$USER_PASSWORD" | cryptsetup open "$home_part" luks_home -
    fi
    
    print_info "Encryption setup complete ✓"
}

# ============================================================================
# LVM SETUP
# ============================================================================

setup_lvm() {
    if [ "$LVM_ENABLED" = false ]; then
        return
    fi
    
    print_step "Setting up LVM..."
    
    local device="/dev/mapper/luks_lvm"
    [ "$ENCRYPTION_ENABLED" = false ] && device="${PRIMARY_DISK}p3"
    [ ! -b "$device" ] && device="${PRIMARY_DISK}3"
    
    pvcreate "$device"
    vgcreate arch "$device"
    
    # Create swap
    lvcreate -L "$SWAP_SIZE" arch -n swap
    
    # Create root
    if [ "$SEPARATE_HOME" = true ] && [ -z "$SECONDARY_DISK" ]; then
        lvcreate -L 100G arch -n root
        lvcreate -l 100%FREE arch -n home
    else
        lvcreate -l 100%FREE arch -n root
    fi
    
    print_info "LVM setup complete ✓"
}

# ============================================================================
# FILESYSTEM CREATION
# ============================================================================

create_filesystems() {
    print_step "Creating filesystems..."
    
    local efi_part="${PRIMARY_DISK}p1"
    local boot_part="${PRIMARY_DISK}p2"
    [ ! -b "$efi_part" ] && efi_part="${PRIMARY_DISK}1"
    [ ! -b "$boot_part" ] && boot_part="${PRIMARY_DISK}2"
    
    # EFI
    mkfs.fat -F32 "$efi_part"
    
    # Boot
    mkfs.ext4 -F "$boot_part"
    
    # Root
    if [ "$LVM_ENABLED" = true ]; then
        mkfs.btrfs -f -L root /dev/mapper/arch-root
        [ "$SEPARATE_HOME" = true ] && [ -z "$SECONDARY_DISK" ] && mkfs.btrfs -f -L home /dev/mapper/arch-home
        mkswap /dev/mapper/arch-swap
    else
        local root_part="${PRIMARY_DISK}p3"
        [ ! -b "$root_part" ] && root_part="${PRIMARY_DISK}3"
        
        if [ "$ENCRYPTION_ENABLED" = true ]; then
            mkfs.btrfs -f -L root /dev/mapper/luks_lvm
        else
            mkfs.btrfs -f -L root "$root_part"
        fi
    fi
    
    # Secondary disk home
    if [ -n "$SECONDARY_DISK" ]; then
        local home_part="${SECONDARY_DISK}p1"
        [ ! -b "$home_part" ] && home_part="${SECONDARY_DISK}1"
        
        if [ "$ENCRYPTION_ENABLED" = true ]; then
            mkfs.btrfs -f -L home /dev/mapper/luks_home
        else
            mkfs.btrfs -f -L home "$home_part"
        fi
    fi
    
    print_info "Filesystems created ✓"
}

# ============================================================================
# MOUNTING
# ============================================================================

mount_filesystems() {
    print_step "Mounting filesystems..."
    
    # Mount root
    if [ "$LVM_ENABLED" = true ]; then
        mount /dev/mapper/arch-root /mnt
        [ "$LVM_ENABLED" = true ] && swapon /dev/mapper/arch-swap
    else
        if [ "$ENCRYPTION_ENABLED" = true ]; then
            mount /dev/mapper/luks_lvm /mnt
        else
            local root_part="${PRIMARY_DISK}p3"
            [ ! -b "$root_part" ] && root_part="${PRIMARY_DISK}3"
            mount "$root_part" /mnt
        fi
    fi
    
    # Create directories
    mkdir -p /mnt/{home,boot,boot/efi}
    
    # Mount boot
    local boot_part="${PRIMARY_DISK}p2"
    [ ! -b "$boot_part" ] && boot_part="${PRIMARY_DISK}2"
    mount "$boot_part" /mnt/boot
    
    # Mount EFI
    local efi_part="${PRIMARY_DISK}p1"
    [ ! -b "$efi_part" ] && efi_part="${PRIMARY_DISK}1"
    mount "$efi_part" /mnt/boot/efi
    
    # Mount home
    if [ "$SEPARATE_HOME" = true ]; then
        if [ "$LVM_ENABLED" = true ]; then
            mount /dev/mapper/arch-home /mnt/home
        elif [ -n "$SECONDARY_DISK" ]; then
            if [ "$ENCRYPTION_ENABLED" = true ]; then
                mount /dev/mapper/luks_home /mnt/home
            else
                local home_part="${SECONDARY_DISK}p1"
                [ ! -b "$home_part" ] && home_part="${SECONDARY_DISK}1"
                mount "$home_part" /mnt/home
            fi
        fi
    fi
    
    print_info "Filesystems mounted ✓"
}

# ============================================================================
# BASE INSTALLATION
# ============================================================================

install_base_system() {
    print_step "Installing base system..."
    
    pacstrap -K /mnt base base-devel linux linux-firmware \
        neovim git sudo networkmanager \
        btrfs-progs dosfstools
    
    [ "$LVM_ENABLED" = true ] && arch-chroot /mnt pacman -S --noconfirm lvm2
    [ "$ENCRYPTION_ENABLED" = true ] && arch-chroot /mnt pacman -S --noconfirm cryptsetup
    
    print_info "Base system installed ✓"
}

# ============================================================================
# SYSTEM CONFIGURATION
# ============================================================================

configure_system() {
    print_step "Configuring system..."
    
    # Generate fstab
    genfstab -U /mnt >> /mnt/etc/fstab
    
    # Timezone
    arch-chroot /mnt ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
    arch-chroot /mnt hwclock --systohc
    
    # Locale
    echo "$LOCALE UTF-8" >> /mnt/etc/locale.gen
    arch-chroot /mnt locale-gen
    echo "LANG=$LOCALE" > /mnt/etc/locale.conf
    
    # Keymap
    echo "KEYMAP=$KEYMAP" > /mnt/etc/vconsole.conf
    
    # Hostname
    echo "$HOSTNAME" > /mnt/etc/hostname
    cat > /mnt/etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
EOF
    
    # Root password
    echo "root:$ROOT_PASSWORD" | arch-chroot /mnt chpasswd
    
    print_info "System configured ✓"
}

# ============================================================================
# BOOTLOADER INSTALLATION
# ============================================================================

install_bootloader() {
    print_step "Installing bootloader..."
    
    arch-chroot /mnt pacman -S --noconfirm grub efibootmgr
    
    # Detect CPU and install microcode
    if grep -q "Intel" /proc/cpuinfo; then
        arch-chroot /mnt pacman -S --noconfirm intel-ucode
    elif grep -q "AMD" /proc/cpuinfo; then
        arch-chroot /mnt pacman -S --noconfirm amd-ucode
    fi
    
    # Configure grub for encryption
    if [ "$ENCRYPTION_ENABLED" = true ]; then
        local root_part="${PRIMARY_DISK}p3"
        [ ! -b "$root_part" ] && root_part="${PRIMARY_DISK}3"
        local uuid=$(blkid -s UUID -o value "$root_part")
        
        # Update grub config
        sed -i "s|GRUB_CMDLINE_LINUX=\"\"|GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=$uuid:luks_lvm root=/dev/mapper/arch-root\"|" /mnt/etc/default/grub
        
        # Update mkinitcpio
        sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck)/' /mnt/etc/mkinitcpio.conf
        arch-chroot /mnt mkinitcpio -P
    fi
    
    # Install grub
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ARCH
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
    
    print_info "Bootloader installed ✓"
}

# ============================================================================
# USER CREATION
# ============================================================================

create_user() {
    print_step "Creating user..."
    
    arch-chroot /mnt useradd -m -G wheel -s /bin/bash "$USERNAME"
    echo "$USERNAME:$USER_PASSWORD" | arch-chroot /mnt chpasswd
    
    # Enable sudo for wheel group
    sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /mnt/etc/sudoers
    
    # Enable services
    arch-chroot /mnt systemctl enable NetworkManager
    
    print_info "User created ✓"
}

# ============================================================================
# POST-INSTALL SCRIPT
# ============================================================================

create_postinstall_script() {
    print_step "Creating post-install script..."
    
    cat > /mnt/home/$USERNAME/install-dotfiles.sh <<'POSTINSTALL'
#!/bin/bash
# Post-installation script for Archie-Dotfiles

echo "Installing Archie-Dotfiles..."
cd ~

# Clone dotfiles
git clone https://github.com/adityamoghaa/Archie-Dotfiles.git ~/.dotfiles

# Run setup script
cd ~/.dotfiles
chmod +x setup.sh
./setup.sh

echo "Dotfiles installation complete!"
POSTINSTALL
    
    chmod +x /mnt/home/$USERNAME/install-dotfiles.sh
    chown 1000:1000 /mnt/home/$USERNAME/install-dotfiles.sh
    
    print_info "Post-install script created at ~/install-dotfiles.sh"
}

# ============================================================================
# MAIN INSTALLATION FLOW
# ============================================================================

main() {
    print_header
    
    check_uefi
    check_internet
    sync_time
    
    show_configuration_menu
    select_disks
    
    partition_disk
    setup_encryption
    setup_lvm
    create_filesystems
    mount_filesystems
    
    install_base_system
    configure_system
    install_bootloader
    create_user
    create_postinstall_script
    
    print_header
    print_step "Installation Complete! 🎉"
    echo
    print_info "Next steps:"
    echo "  1. Reboot: umount -R /mnt && reboot"
    echo "  2. Login as: $USERNAME"
    echo "  3. Run: ~/install-dotfiles.sh"
    echo
    print_info "Your passwords:"
    echo "  User: $USERNAME"
    echo "  Hostname: $HOSTNAME"
    echo
    pause
}

# Run main function
main