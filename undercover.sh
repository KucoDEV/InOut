#!/bin/bash

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
RED='\033[1;31m'
PURPLE='\033[1;35m'
WHITE='\033[1;37m'
NC='\033[0m'

loading_animation() {
    local message="$1"
    local delay=0.08
    echo -ne "${YELLOW}${message}${NC} "
    for i in {1..10}; do
        echo -ne "▓"
        sleep $delay
    done
    echo -e " ${GREEN}✔ Terminé!${NC}"
}


clear
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${PURPLE}        ___ _  _ _____ ___  _   _ _____ ${NC}"
echo -e "${PURPLE}       |_ _| \| |_   _/ _ \| | | |_   _|${NC}"
echo -e "${PURPLE}        | || .' | | || (_) | |_| | | |  ${NC}"
echo -e "${PURPLE}       |___|_|\_| |_| \___/ \___/  |_|  ${NC}"
echo -e "${PURPLE}                                        ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"

loading_animation " Vérification de l'environnement GNOME   | "


if [[ "$XDG_CURRENT_DESKTOP" != "GNOME" ]]; then
    echo -e "${RED} Ce script fonctionne uniquement sous GNOME.${NC}"
    exit 1
fi

CONFIG_DIR="config"
THEME_BACKUP="$CONFIG_DIR/gnome_theme.bak"
ICON_BACKUP="$CONFIG_DIR/gnome_icons.bak"
CURSOR_BACKUP="$CONFIG_DIR/gnome_cursor.bak"

WIN_THEME="Windows-10"
WIN_ICONS="Windows-10-Icons"
WIN_CURSOR="Windows-10-Cursors"

ASSETS_DIR="Assets"
WIN_WALLPAPER="$ASSETS_DIR/win10.jpg"
LIN_WALLPAPER="$ASSETS_DIR/linux.jpg"

loading_animation " Sauvegarde de la configuration actuelle | "


CURRENT_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme)
CURRENT_ICONS=$(gsettings get org.gnome.desktop.interface icon-theme)
CURRENT_CURSOR=$(gsettings get org.gnome.desktop.interface cursor-theme)


if [ ! -f "$THEME_BACKUP" ]; then
    echo "$CURRENT_THEME" > "$THEME_BACKUP"
    echo "$CURRENT_ICONS" > "$ICON_BACKUP"
    echo "$CURRENT_CURSOR" > "$CURSOR_BACKUP"
    echo -e "${GREEN} Configuration originale sauvegardée.${NC}"
fi

toggle_mode() {
    if [[ $(gsettings get org.gnome.desktop.interface gtk-theme) != "'$WIN_THEME'" ]]; then
        echo -e "${YELLOW}                                         | \n Activation du mode Undercover...        | ${NC}"
        loading_animation " Changement du thème GTK                 | "
        gsettings set org.gnome.desktop.interface gtk-theme "$WIN_THEME"

        loading_animation " Changement des icônes                   | "
        gsettings set org.gnome.desktop.interface icon-theme "$WIN_ICONS"

        loading_animation " Changement du curseur                   | "
        gsettings set org.gnome.desktop.interface cursor-theme "$WIN_CURSOR"

        loading_animation " Modification du fond d'écran            | "
        gsettings set org.gnome.desktop.background picture-uri "$ASSETS_DIR/win10.jpg"
        gsettings set org.gnome.desktop.background picture-uri-dark "$ASSETS_DIR/win10.jpg"

        loading_animation " Désactivation des animations GNOME      | "
        gsettings set org.gnome.desktop.interface enable-animations false

        echo -e "${GREEN}\n         Mode Undercover activé!\n${NC}"
    else
        echo -e "${YELLOW}                                         | \n Retour au mode normal...                | ${NC}"

        loading_animation " Restauration du thème original          | "
        gsettings set org.gnome.desktop.interface gtk-theme "$(cat $THEME_BACKUP)"

        loading_animation " Restauration des icônes originales      | "
        gsettings set org.gnome.desktop.interface icon-theme "$(cat $ICON_BACKUP)"

        loading_animation " Restauration du curseur original        | "
        gsettings set org.gnome.desktop.interface cursor-theme "$(cat $CURSOR_BACKUP)"

        loading_animation " Réactivation des animations GNOME       | "
        gsettings set org.gnome.desktop.interface enable-animations true

        loading_animation " Restauration du fond d'écran original   | "
        gsettings set org.gnome.desktop.background picture-uri "$ASSETS_DIR/linux.jpg"
        gsettings set org.gnome.desktop.background picture-uri-dark "$ASSETS_DIR/linux.jpg"

        echo -e "${GREEN}\n         Mode normal restauré!\n${NC}"
    fi
}

toggle_mode