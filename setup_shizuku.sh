#!/bin/bash

echo "Buscando el ejecutable 'rish' de Shizuku..."
echo "Esto puede tardar un momento..."

# Search for the rish executable in common locations
RISH_PATH=$(find /storage/emulated/0/Android/data /data/data -type f -name "rish" 2>/dev/null)

if [ -n "$RISH_PATH" ]; then
    # Get the directory containing rish
    RISH_DIR=$(dirname "$RISH_PATH")
    
    echo "¡'rish' encontrado en: $RISH_DIR!"
    
    # Line to add to .bashrc
    EXPORT_LINE="export PATH=\$PATH:$RISH_DIR"
    
    # Check if the line is already in .bashrc
    if grep -qF "$EXPORT_LINE" ~/.bashrc;
 then
        echo "La configuración de Shizuku ya existe en tu .bashrc. No se necesita hacer nada."
    else
        echo "Añadiendo la configuración de Shizuku a tu archivo ~/.bashrc..."
        # Add the export line to .bashrc
        echo -e "\n# Configuración para Shizuku (añadido por script)" >> ~/.bashrc
        echo "$EXPORT_LINE" >> ~/.bashrc
        echo "¡Configuración añadida!"
    fi
    
    echo -e "\nPor favor, reinicia Termux (cierra y vuelve a abrir la app) para que los cambios surtan efecto."
    echo "Después de reiniciar, el comando 'rish' debería funcionar."

else
    echo "No se pudo encontrar el ejecutable 'rish'."
    echo "Por favor, asegúrate de que la aplicación de Shizuku esté instalada y de que hayas seguido los pasos de configuración dentro de la app."
fi
