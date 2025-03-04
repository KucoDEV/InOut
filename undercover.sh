#!/bin/bash

# Définition des couleurs ANSI
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
RED='\033[1;31m'
PURPLE='\033[1;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# Fonction d'animation de chargement
loading_animation() {
    local message="$1"
    local delay=0.08
    echo -ne "${YELLOW}${message}${NC} "
    for _ in {1..10}; do
        echo -ne "▓"
        sleep "$delay"
    done
    echo -e " ${GREEN}✔ Terminé!${NC}"
}

# Effacer l'écran et afficher l'ASCII ART
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${PURPLE}        ___ _  _ _____ ___  _   _ _____ ${NC}"
echo -e "${PURPLE}       |_ _| \| |_   _/ _ \| | | |_   _|${NC}"
echo -e "${PURPLE}        | || .' | | || (_) | |_| | | |  ${NC}"
echo -e "${PURPLE}       |___|_|\_| |_| \___/ \___/  |_|  ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"

# Vérification de l'environnement GNOME
loading_animation " Vérification de l'environnement GNOME   | "
if [[ "$XDG_CURRENT_DESKTOP" != "GNOME" ]]; then
    echo -e "${RED} Ce script fonctionne uniquement sous GNOME.${NC}"
    exit 1
fi


# Création config
if [ ! -d "$HOME/.config" ]; then
    mkdir "$HOME/.config"
fi
CONFIG_DIR="$HOME/.config"
THEME_BACKUP="$CONFIG_DIR/gnome_theme.bak"
ICON_BACKUP="$CONFIG_DIR/gnome_icons.bak"
CURSOR_BACKUP="$CONFIG_DIR/gnome_cursor.bak"


# Création fichier windows
if [ ! -d "$HOME/.themes" ]; then
    mkdir "$HOME/.themes"
    cp -R "Windows-10" "$HOME/.themes"
    loading_animation = " Copie du thème Windows-10               | "
fi

if [ ! -d "$HOME/.icons" ]; then
    mkdir "$HOME/.icons"
    cp -R "Windows-10-Icons" "$HOME/.icons"
    loading_animation = " Copie des icônes Windows-10             | "
fi
WIN_THEME_DIR="$HOME/.themes"
WIN_ICONS_DIR="$HOME/.icons"
WIN_THEME="Windows-10"
WIN_ICONS="Windows-10-Icons"
WIN_CURSOR="Windows-10-Cursors"


# Création du dossier assets
if [ ! -d "$HOME/.undercover" ]; then
    mkdir "$HOME/.undercover"
    cp "Assets/win10.jpg" "$HOME/.undercover"
    cp "Assets/linux.jpg" "$HOME/.undercover"
    loading_animation " Copie des fonds d'écran                 | "
fi
ASSETS_DIR="$HOME/.undercover"
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
        gsettings set org.gnome.desktop.background picture-uri "file://$ASSETS_DIR/win10.jpg"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$ASSETS_DIR/win10.jpg"

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
        gsettings set org.gnome.desktop.background picture-uri "file://$ASSETS_DIR/linux.jpg"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$ASSETS_DIR/linux.jpg"

        echo -e "${GREEN}\n         Mode normal restauré!\n${NC}"
    fi
}

toggle_mode
