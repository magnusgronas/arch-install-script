#!/usr/bin/env bash

install_yay() {
    echo ":: Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    if ! command -v yay &>/dev/null; then
        echo "Cloning yay repo into ~/yay..."
        git clone https://aur.archlinux.org/yay.git ~/yay
        cd ~/yay || exit
        echo "Building yay..."
        makepg -si --noconfirm
    fi
}

is_installed() {
    pacman -Qi "$1" &>/dev/null || pacman -Qg "$1" &>/dev/null
}

install_util() {
    packages=("$@")
    installing=()

    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            installing+=("$pkg")
        fi
    done

    if [ ${#installing[@]} -gt 0 ]; then
        echo "Installing:"
        for pkg in "${installing[@]}"; do
            echo " – $pkg"
        done
        yay -S --noconfirm "${installing[@]}"
    fi
}

install_packages() {
    echo " :: Installing packages"
}

lenovo_yoga_laptop_audio_fix() {
    echo " :: Audio fix for lenovo yoga pro 7 laptop"
    echo "Do you need this fix (y/N)"
}

echo "Updating system..."
sudo pacman -Syu --noconfirm

install_yay
