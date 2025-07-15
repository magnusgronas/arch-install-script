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
    gum format "Please edit \`packages.conf\` to add or remove any packages you want to install"
    echo
    printf "Press \e[32many\e[0m key to start installation or \e[31mctrl-c\e[0m to exit"
    read -n 1 -sr
    printf "\e[34m :: \e[0mUpdating system and syncing pacman\n"
    sudo pacman -Syu --noconfirm

    if ! command -v yay &>/dev/null; then
        printf "\e[34m :: \e[0mInstalling yay...\n"
        sudo pacman -S --needed --noconfirm git base-devel
        echo "Cloning yay repo into ~/yay..."
        git clone https://aur.archlinux.org/yay.git ~/yay
        cd ~/yay || exit
        echo "Building yay..."
        makepkg -si --noconfirm
    fi
    printf "\e[33m info: \e[0myay installed -- skipping\n"

    printf "\e[34m :: \e[0mInstalling gum for a pretty cli experience\n"
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
            printf "\e[34m – \e[0m%s\n" "$pkg"
        done
        yay -S --noconfirm "${installing[@]}"
    fi
}

install_packages() {
    printf "\e[34m :: \e[0mInstalling packages\n"
}

lenovo_yoga_laptop_audio_fix() {
    printf "\e[34m :: \e[0mAudio fix for lenovo yoga pro 7 laptop\n"
    gum confirm "Apply fix?" --prompt.padding "0 10" --selected.margin "0 4" && do_audiofix || return
}

do_audiofix() {
    if [ ! -f "/etc/modprobe.d/mysound.conf" ]; then
        sudo touch /etc/modprobe.d/mysound.conf
        echo "options snd_sof_intel_hda_generic hda_model=alc287-yoga9-bass-spk-pin" | sudo tee /etc/modprobe.d/mysound.conf
    else
        printf "\e[33m/etc/modprobe.d/mysound.conf\e[0m already exists\n"
        printf "Go to the file and append \e[32m\"options snd_sof_intel_hda_generic hda_model=alc287-yoga9-bass-spk-pin\"\e[0m to it\n"
        printf " \e[31mNOTE: \e[0mYou need to reboot for the fix to work\n"
    fi
}

main() {
    greeter
    pre_install
}

pre_install
lenovo_yoga_laptop_audio_fix
