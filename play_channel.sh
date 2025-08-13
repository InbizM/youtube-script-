#!/bin/bash

# --- CONFIGURACIÓN ---
CHANNEL_URL_BASE="https://youtube.com/@metaldoradocrypto"

# --- FUNCIONES ---

# Función para obtener un TinyURL
get_tiny_url() {
    local LONG_URL=$1
    local TINY_URL=$(curl -s "https://tinyurl.com/api-create.php?url=$LONG_URL")
    echo "$TINY_URL"
}

# Función para reproducir un video (normal, short o prueba)
play_video() {
    local TITLE=$1
    local URL=$2
    local DURATION=$3

    echo "-----------------------------------------------------"
    echo "Reproduciendo: $TITLE"
    echo "URL: $URL"
    echo "Duración (según yt-dlp): $DURATION segundos"

    # Obtener TinyURL
    TINY_URL=$(get_tiny_url "$URL")
    echo "TinyURL: $TINY_URL"

    # Abrir la TinyURL en el navegador
    termux-open-url "$TINY_URL"

    # Calcular tiempo de espera
    WAIT_TIME=$((DURATION + 2))
    echo "El script esperará en segundo plano durante $WAIT_TIME segundos..."
    sleep "$WAIT_TIME"

    # Al finalizar, forzar el cierre de la aplicación de YouTube
    echo "Video finalizado. Forzando el cierre de YouTube..."
    ~/bin/rish -c "am force-stop com.google.android.youtube" < /dev/null
    sleep 1 # Pausa para que el sistema se estabilice
    echo "-----------------------------------------------------"
}

# Función para ejecutar una prueba rápida
run_test() {
    echo "--- INICIANDO PRUEBA RÁPIDA ---"
    echo "Usando video de prueba predeterminado."

    # Video de prueba predeterminado
    TEST_URL="https://www.youtube.com/watch?v=icPHcK_cCF4"
    TEST_TITLE="Countdown 5 seconds timer"
    TEST_DURATION=6

    play_video "VIDEO DE PRUEBA: $TEST_TITLE" "$TEST_URL" "$TEST_DURATION"
    
    echo "--- PRUEBA RÁPIDA FINALIZADA ---"
    echo "Si la prueba funcionó, el script continuará con la lista de reproducción normal."
    sleep 3
    echo
}


# --- LÓGICA PRINCIPAL DEL SCRIPT ---

# Función para obtener y barajar todos los videos (normales y shorts)
get_shuffled_videos() {
    echo "Obteniendo y barajando todos los videos del canal..."
    
    # Obtener videos normales y shorts, combinarlos y barajarlos
    (yt-dlp --flat-playlist -j "$CHANNEL_URL_BASE/videos" 2>/dev/null;     yt-dlp --flat-playlist -j "$CHANNEL_URL_BASE/shorts" 2>/dev/null) |     jq -c ". | select(.duration and .duration <= 600) | {url: .url, duration: (.duration|round), title: .title}" |     shuf
}


# 1. Ejecutar la prueba rápida
run_test

# 2. Bucle de reproducción infinita
while true; do
    echo "Iniciando un nuevo ciclo de reproducción..."
    SHUFFLED_VIDEOS=$(get_shuffled_videos)
    
    if [ -z "$SHUFFLED_VIDEOS" ]; then
        echo "No se encontraron videos o hubo un error. Esperando 60 segundos para reintentar..."
        sleep 60
        continue
    fi

    echo "Lista de reproducción creada. Empezando a reproducir..."
    
    echo "$SHUFFLED_VIDEOS" | while IFS= read -r line; do
        # Extraer datos del video
        URL=$(echo "$line" | jq -r ".url")
        DURATION=$(echo "$line" | jq -r ".duration")
        TITLE=$(echo "$line" | jq -r ".title")

        # Reproducir el video
        play_video "$TITLE" "$URL" "$DURATION"
    done

    echo "¡Todos los videos de esta ronda se han reproducido!"
    echo "Reiniciando el ciclo para volver a reproducir en orden aleatorio..."
    sleep 5
done

