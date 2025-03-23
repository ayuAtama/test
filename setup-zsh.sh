#!/bin/bash

# Clone repository
echo "Cloning repository..."
git clone https://github.com/ayuAtama/OhMyZsh-Widows-Git-Bash.git ~/ohmyzsh-git-bash

# Pindah ke folder hasil clone
cd ~/ohmyzsh-git-bash || { echo "Gagal masuk ke direktori"; exit 1; }

# Pindahkan semua isi folder zsh-bin ke root /
echo "Memindahkan file dari zsh-bin ke root /"
cp -r -v zsh-bin/* /

# Hapus folder zsh-bin yang kosong
# rmdir zsh-bin

# Pindahkan semua isi oh-my-zsh_config ke home (~)
echo "Memindahkan isi oh-my-zsh_config ke $HOME"
cp -r -v oh-my-zsh_config/* ~

# Hapus folder oh-my-zsh_config yang kosong
# rmdir oh-my-zsh_config

# Hapus folder sementara
cd ~
# rm -rf ~/ohmyzsh-git-bash

echo "Mengecek apakah Chocolatey sudah terinstal..."
if ! command -v choco &> /dev/null; then
    echo "Chocolatey tidak ditemukan! Memulai instalasi..."
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
else
    echo "Chocolatey sudah terinstal!"
fi

echo "Menginstall Nerd-Font"
powershell choco install nerd-fonts-meslo -y
echo "Install Font Selesai"
echo "Install jq"
powershell choco install jq -y
echo "jq terpasang"

echo "Masuk Direktori Windows Terminal"

# Lokasi settings.json Windows Terminal
CONFIG_PATH="$LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

# cd "$CONFIG_PATH" 
echo "Applying Theme"


# Backup settings.json sebelum diedit
cp "$CONFIG_PATH" "${CONFIG_PATH}.backup"

# Menambahkan tema & skema warna "Catppuccin Macchiato"
jq '
  .themes += [{
    "name": "Catppuccin Macchiato",
    "tab": {
      "background": "#24273AFF",
      "showCloseButton": "always",
      "unfocusedBackground": null
    },
    "tabRow": {
      "background": "#1E2030FF",
      "unfocusedBackground": "#181926FF"
    },
    "window": {
      "applicationTheme": "dark"
    }
  }]
  | .schemes += [{
    "name": "Catppuccin Macchiato",
    "cursorColor": "#F4DBD6",
    "selectionBackground": "#5B6078",
    "background": "#24273A",
    "foreground": "#CAD3F5",
    "black": "#494D64",
    "red": "#ED8796",
    "green": "#A6DA95",
    "yellow": "#EED49F",
    "blue": "#8AADF4",
    "purple": "#F5BDE6",
    "cyan": "#8BD5CA",
    "white": "#B8C0E0",
    "brightBlack": "#5B6078",
    "brightRed": "#ED8796",
    "brightGreen": "#A6DA95",
    "brightYellow": "#EED49F",
    "brightBlue": "#8AADF4",
    "brightPurple": "#F5BDE6",
    "brightCyan": "#8BD5CA",
    "brightWhite": "#A5ADCB"
  }]
  | (.profiles.list[] | select(.source == "Git")) += {   
    "colorScheme": "Catppuccin Macchiato",
    "font": { "face": "MesloLGS Nerd Font" }
  }
' "$CONFIG_PATH" > settings_new.json

# Ganti file lama dengan yang baru
mv settings_new.json "$CONFIG_PATH"

echo "Konfigurasi Windows Terminal berhasil diperbarui!"

echo "Selesai!"


#Untested

# Backup settings.json sebelum diedit
# cp "$CONFIG_PATH" "${CONFIG_PATH}.backup"

# Cari GUID dari profil yang memiliki name "PowerShell"
# POWERSHELL_GUID=$(jq -r '.profiles.list[] | select(.name == "PowerShell") | .guid' "$CONFIG_PATH")

# # Pastikan GUID ditemukan sebelum mengedit file
# if [[ -n "$POWERSHELL_GUID" ]]; then
#   jq --arg newDefault "$POWERSHELL_GUID" '.defaultProfile = $newDefault' "$CONFIG_PATH" > settings_new.json
#   mv settings_new.json "$CONFIG_PATH"
#   echo "✅ defaultProfile berhasil diubah ke PowerShell ($POWERSHELL_GUID)"
# else
#   echo "⚠️ Profil PowerShell tidak ditemukan!"
# fi
