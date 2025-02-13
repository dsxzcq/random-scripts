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
# Language Selection
# -----------------------------------------------------
echo "Select your language / Selecciona tu idioma:"
echo "1) English"
echo "2) Español"
read -p "Enter the number corresponding to your choice: " lang_choice

if [[ $lang_choice == 1 ]]; then
    lang="en"
elif [[ $lang_choice == 2 ]]; then
    lang="es"
else
    echo "Invalid choice. Exiting..."
    exit 1
fi

lang_file="https://raw.githubusercontent.com/dsxzcq/random-scripts/main/random-hyprdots-installer/langs.json"
lang_strings=$(curl -s "$lang_file" | jq -r ".$lang")

get_string() {
    echo "$lang_strings" | jq -r ".$1"
}

# -----------------------------------------------------
# Header
# -----------------------------------------------------
echo -e "\033[0;32m"
cat <<"EOF"
          _          _             _          _            _                   _             _             _            _      
         /\ \       /\ \     _    / /\       /\ \         / /\                _\ \          _\ \          /\ \         /\ \    
         \ \ \     /  \ \   /\_\ / /  \      \_\ \       / /  \              /\__ \        /\__ \        /  \ \       /  \ \   
         /\ \_\   / /\ \ \_/ / // / /\ \__   /\__ \     / / /\ \            / /_ \_\      / /_ \_\      / /\ \ \     / /\ \ \  
        / /\/_/  / / /\ \___/ // / /\ \___\ / /_ \ \   / / /\ \ \          / / /\/_/     / / /\/_/     / / /\ \_\   / / /\ \_\ 
       / / /    / / /  \/____/ \ \ \ \/___// / /\ \ \ / / /  \ \ \        / / /         / / /         / /_/_ \/_/  / / /_/ / / 
      / / /    / / /    / / /   \ \ \     / / /  \/_// / /___/ /\ \      / / /         / / /         / /____/\    / / /__\/ /  
     / / /    / / /    / / /_    \ \ \   / / /      / / /_____/ /\ \    / / / ____    / / / ____    / /\____\/   / / /_____/   
 ___/ / /__  / / /    / / //_/\__/ / /  / / /      / /_________/\ \ \  / /_/_/ ___/\ / /_/_/ ___/\ / / /______  / / /\ \ \     
/\__\/_/___\/ / /    / / / \ \/___/ /  /_/ /      / / /_       __\ \_\/_______/\__\//_______/\__\// / /_______\/ / /  \ \ \    
\/_________/\/_/     \/_/   \_____\/   \_\/       \_\___\     /____/_/\_______\/    \_______\/    \/__________/\/_/    \_\/    
                                                                                                                               
EOF
echo "$(get_string "title")"
echo -e "\033[0m"

echo "$(get_string "sudo_prompt")"
sudo -v
if [ $? -ne 0 ]; then
    echo "$(get_string "sudo_fail")"
    exit 1
fi

show_menu() {
    echo "$(get_string "menu_title")"
    echo "1) $(get_string "menu_option1")"
    echo "2) $(get_string "menu_option2")"
    echo "3) $(get_string "menu_option3")"
    echo "4) $(get_string "menu_option4")"
    echo "5) $(get_string "menu_option5")"
    echo "6) $(get_string "menu_option6")"
    echo
}
while true; do
    show_menu
    read -p "$(get_string "menu_prompt") " choice

    case $choice in
        1)
            echo ":: $(get_string "installing_option1")"
            eval $Downloader1
            break
            ;;
        2)
            echo ":: $(get_string "installing_option2")"
            eval $Downloader2
            break
            ;;
        3)
            echo -e "\033[0;31m"
            echo ":: $(get_string "warning_old")"
            echo -e "\033[0m"
            read -p "$(get_string "confirm_install") (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                echo ":: $(get_string "installing_option3")"
                eval $Downloader3
                break
            else
                echo ":: $(get_string "install_canceled")"
                sleep 2
                clear
            fi
            ;;
        4)
            echo ":: $(get_string "installing_option4")"
            eval $Downloader4
            break
            ;;
        5)
            echo ":: $(get_string "installing_option5")"
            eval $Downloader5
            break
            ;;
        6)
            echo ":: $(get_string "exiting")"
            exit 0
            ;;
        *)
            echo ":: $(get_string "invalid_choice")"
            sleep 2
            clear
            ;;
    esac
done

echo ":: $(get_string "install_complete")"
