#!/bin/bash

echo "--- Configurando el entorno para play_channel.sh ---"

# 1. Pedir permisos de almacenamiento
echo "[1/4] Solicitando permisos de almacenamiento..."
termux-setup-storage

# 2. Crear directorio local para binarios
echo "[2/4] Creando directorio ~/bin..."
mkdir -p ~/bin

# 3. Copiar archivos de Shizuku
SHIZUKU_DIR="/storage/emulated/0/Android/media/shizuku"
echo "[3/4] Copiando archivos de Shizuku desde $SHIZUKU_DIR..."
if [ -f "$SHIZUKU_DIR/rish" ] && [ -f "$SHIZUKU_DIR/rish_shizuku.dex" ]; then
    cp "$SHIZUKU_DIR/rish" ~/bin/rish
    cp "$SHIZUKU_DIR/rish_shizuku.dex" ~/bin/rish_shizuku.dex
    chmod +x ~/bin/rish
    chmod +x ~/bin/rish_shizuku.dex
    echo "Archivos de Shizuku copiados correctamente."
else
    echo "ERROR: No se encontraron los archivos de Shizuku en $SHIZUKU_DIR."
    echo "Por favor, asegúrate de que Shizuku esté instalado y activo."
    exit 1
fi

# 4. Configurar .bashrc
echo "[4/4] Configurando el archivo .bashrc..."
BASHRC_FILE=~/.bashrc
PATH_LINE='export PATH=$PATH:~/bin'
APP_ID_LINE='export RISH_APPLICATION_ID=com.termux'

# Añadir PATH si no existe
if ! grep -qF "$PATH_LINE" "$BASHRC_FILE"; then
    echo -e "\n# Añadido por script de configuración" >> "$BASHRC_FILE"
    echo "$PATH_LINE" >> "$BASHRC_FILE"
    echo "Ruta de ~/bin añadida al PATH."
else
    echo "La ruta de ~/bin ya está en el PATH."
fi

# Añadir RISH_APPLICATION_ID si no existe
if ! grep -qF "$APP_ID_LINE" "$BASHRC_FILE"; then
    echo "$APP_ID_LINE" >> "$BASHRC_FILE"
    echo "RISH_APPLICATION_ID configurado."
else
    echo "RISH_APPLICATION_ID ya está configurado."
fi

echo -e "\n--- ¡Configuración completada! ---"
echo "Por favor, REINICIA Termux (cierra y vuelve a abrir la app) para que los cambios surtan efecto."
