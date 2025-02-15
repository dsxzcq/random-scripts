#!/bin/bash
set -e

DOWNLOADERS_FILE="https://raw.githubusercontent.com/dsxzcq/random-scripts/main/random-hyprdots-installer/downloaders.json"
lang_file="https://raw.githubusercontent.com/dsxzcq/random-scripts/main/random-hyprdots-installer/langs.json"

function get_string() {
    echo "$lang_strings" | jq -r ".$1"
}

function check_sudo() {
    sudo -v || { echo "$(get_string "sudo_fail")"; exit 1; }
}

function load_downloaders() {
    downloaders=$(curl -s "$DOWNLOADERS_FILE")
    if [[ -z "$downloaders" ]]; then
        echo ":: $(get_string "download_failed")"
        exit 1
    fi
    if ! echo "$downloaders" | jq . >/dev/null 2>&1; then
        echo ":: $(get_string "invalid_json")"
        exit 1
    fi
}

function show_hyprdots_menu() {
    echo "$(get_string "menu_title")"
    i=1
    mapfile -t hyprdots_list < <(echo "$downloaders" | jq -r 'keys[]')
    for option in "${hyprdots_list[@]}"; do
        echo "$i) $option"
        hyprdots_options["$i"]="$option"
        ((i++))
    done
    echo "$i) $(get_string "menu_option6")"
}

function show_distro_menu() {
    local selected_hyprdot="$1"
    echo "$(get_string "select_distro")"
    i=1
    mapfile -t distro_list < <(echo "$downloaders" | jq -r ".[\"$selected_hyprdot\"] | keys[]")
    for distro in "${distro_list[@]}"; do
        echo "$i) $distro"
        distro_options["$i"]="$distro"
        ((i++))
    done
    echo "$i) $(get_string "menu_option6")"
}

function cleanup() {
    echo ":: Cleaning up..."
    rm -rf ~/HyDE ~/Arch-Hyprland 2>/dev/null || true
}

trap cleanup EXIT

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

lang_strings=$(curl -s "$lang_file" | jq -r ".$lang")

clear
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
check_sudo

load_downloaders

declare -A hyprdots_options
show_hyprdots_menu
read -p "$(get_string "menu_prompt") " hyprdot_choice
if [[ $hyprdot_choice -ge 1 && $hyprdot_choice -le ${#hyprdots_options[@]} ]]; then
    selected_hyprdot="${hyprdots_options[$hyprdot_choice]}"
elif [[ $hyprdot_choice -eq $((${#hyprdots_options[@]} + 1)) ]]; then
    echo ":: $(get_string "exiting")"
    exit 0
else
    echo ":: $(get_string "invalid_choice")"
    exit 1
fi

declare -A distro_options
show_distro_menu "$selected_hyprdot"
read -p "$(get_string "distro_prompt") " distro_choice
if [[ $distro_choice -ge 1 && $distro_choice -le ${#distro_options[@]} ]]; then
    selected_distro="${distro_options[$distro_choice]}"
    downloader_command=$(echo "$downloaders" | jq -r ".[\"$selected_hyprdot\"][\"$selected_distro\"]")
    echo ":: $(get_string "installing_option_prefix") $selected_hyprdot ($selected_distro)"
    eval "$downloader_command"
elif [[ $distro_choice -eq $((${#distro_options[@]} + 1)) ]]; then
    echo ":: $(get_string "exiting")"
    exit 0
else
    echo ":: $(get_string "invalid_choice")"
    exit 1
fi

echo ":: $(get_string "process_complete")"
