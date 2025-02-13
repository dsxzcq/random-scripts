#!/bin/bash
clear

# -----------------------------------------------------
# Installer Options
# -----------------------------------------------------
Downloader1="bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh)"
Downloader2="bash <(curl -s 'https://end-4.github.io/dots-hyprland-wiki/setup.sh')"
Downloader3="pacman -S --needed git base-devel && git clone --depth 1 https://github.com/prasanthrangan/hyprdots ~/HyDE && cd ~/HyDE/Scripts && ./install.sh"
Downloader4="pacman -S --needed git base-devel && git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE && cd ~/HyDE/Scripts && ./install.sh"
Downloader5="git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git ~/Arch-Hyprland && cd ~/Arch-Hyprland && chmod +x install.sh && ./install.sh"

# -----------------------------------------------------
# Header
# -----------------------------------------------------
echo -e "\033[0;32m"
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/

EOF
echo "GDT Dotfiles for Hyprland"
echo -e "\033[0m"

echo ":: Please enter your password to grant administrative privileges."
sudo -v
if [ $? -ne 0 ]; then
    echo ":: Incorrect password or no sudo privileges. Exiting..."
    exit 1
fi

show_menu() {
    echo "Please choose between: "
    echo "1) My Linux For Work Hyprdots"
    echo "2) End 4 Hyprdots"
    echo "3) HyDE OLD Hyprdots (Discontinued)"
    echo "4) HyDE Hyprdots"
    echo "5) JaKooLit HyprDots"
    echo "6) Exit"
    echo
}

while true; do
    show_menu
    read -p "Enter the number corresponding to your choice: " choice

    case $choice in
        1)
            echo ":: Installing My Linux For Work"
            eval $Downloader1
            break
            ;;
        2)
            echo ":: Installing End 4 Hyprdots"
            eval $Downloader2
            break
            ;;
        3)
            echo -e "\033[0;31m"
            echo ":: WARNING: HyDE OLD Hyprdots is discontinued and no longer supported."
            echo ":: It is recommended to choose a different option."
            echo -e "\033[0m"
            read -p "Do you want to continue with the installation? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                echo ":: Installing HyDE OLD Hyprdots"
                eval $Downloader3
                break
            else
                echo ":: Installation canceled. Returning to the main menu..."
                sleep 2
                clear
            fi
            ;;
        4)
            echo ":: Installing HyDE Hyprdots"
            eval $Downloader4
            break
            ;;
        5)
            echo ":: Installing JaKooLit HyprDots"
            eval $Downloader5
            break
            ;;
        6)
            echo ":: Exiting..."
            exit 0
            ;;
        *)
            echo ":: Invalid choice. Please try again."
            sleep 2
            clear
            ;;
    esac
done
