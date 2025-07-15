#!/usr/bin/env bash

greeter() {
    cat <<"EOF"

┌──────────────────────────────────────────────────────────────────────────────────┐
│                                                                                  │
│  _____/\\\\\\\\\_____/\\\_________________/\\\\\\\\\\\____/\\\\\\\\\\\_          │
│   ___/\\\\\\\\\\\\\__\/\\\_______________/\\\/////////\\\_\/////\\\///__         │
│    __/\\\/////////\\\_\/\\\______________\//\\\______\///______\/\\\_____        │
│     _\/\\\_______\/\\\_\/\\\_______________\////\\\_____________\/\\\_____       │
│      _\/\\\\\\\\\\\\\\\_\/\\\__________________\////\\\__________\/\\\_____      │
│       _\/\\\/////////\\\_\/\\\_____________________\////\\\_______\/\\\_____     │
│        _\/\\\_______\/\\\_\/\\\______________/\\\______\//\\\______\/\\\_____    │
│         _\/\\\_______\/\\\_\/\\\\\\\\\\\\\\\_\///\\\\\\\\\\\/____/\\\\\\\\\\\_   │  
│          _\///________\///__\///////////////____\///////////_____\///////////__  │  Arch Linux Setup Interface
│                                                                                  │  by: Magnus Grønås 
└──────────────────────────────────────────────────────────────────────────────────┘


EOF
}

pre_install() {
    greeter
    echo -e "\e[34m :: \e[0mUpdating system and syncing pacman"
    sudo pacman -Syu --noconfirm

    echo -e "\e[34m :: \e[0mInstalling yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    if ! command -v yay &>/dev/null; then
        echo "Cloning yay repo into ~/yay..."
        git clone https://aur.archlinux.org/yay.git ~/yay
        cd ~/yay || exit
        echo "Building yay..."
        makepg -si --noconfirm
    fi

    echo -e "\e[34m :: \e[0mInstalling gum for a pretty cli experience"
    sudo pacman -S --needed --noconfirm gum
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
    gum

}

pre_install
