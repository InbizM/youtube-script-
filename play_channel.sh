#!/bin/bash

# --- CONFIGURACIÓN ---
CHANNEL_URL_BASE="https://youtube.com/@metaldoradocrypto"
PLAY_SHORT_EVERY=10 # Reproducir un short cada 10 videos normales

# --- FUNCIONES ---

# Función para reproducir un video (normal, short o prueba)
play_video() {
    local TITLE=$1
    local URL=$2
    local DURATION=$3

    echo "-----------------------------------------------------"
    echo "Reproduciendo: $TITLE"
    echo "URL: $URL"
    echo "Duración (según yt-dlp): $DURATION segundos"

    # Abrir la URL en YouTube
    termux-open-url "$URL"

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

# 1. Ejecutar la prueba rápida
run_test

# 2. Continuar con la lógica normal del canal
echo "Obteniendo lista de shorts para reproducción aleatoria..."
SHORTS_DATA=$(yt-dlp --flat-playlist -j "$CHANNEL_URL_BASE/shorts" 2>/dev/null | jq -c '. | select(.duration) | {url: .url, duration: (.duration|round), title: .title}')
NUM_SHORTS=$(echo "$SHORTS_DATA" | wc -l)

if [ "$NUM_SHORTS" -eq 0 ]; then
    echo "Advertencia: No se encontraron shorts en el canal."
fi

echo "Obteniendo información de los videos normales del canal..."
VIDEO_COUNTER=0

# Procesamos solo los videos normales en este bucle
yt-dlp --flat-playlist -j "$CHANNEL_URL_BASE/videos" 2>/dev/null | \
    jq -c '. | select(.duration) | {url: .url, duration: (.duration|round), title: .title}' | \
    while IFS= read -r line; do
        VIDEO_COUNTER=$((VIDEO_COUNTER + 1))

        # Extraer datos del video normal
        URL=$(echo "$line" | jq -r '.url')
        DURATION=$(echo "$line" | jq -r '.duration')
        TITLE=$(echo "$line" | jq -r '.title')

        # Reproducir el video normal
        play_video "$TITLE" "$URL" "$DURATION"

        # Comprobar si es hora de un short aleatorio
        if (( VIDEO_COUNTER % PLAY_SHORT_EVERY == 0 )) && [ "$NUM_SHORTS" -gt 0 ]; then
            echo
            echo "¡BONUS: Reproduciendo un short aleatorio!"
            
            # Elegir un short al azar
            RANDOM_LINE_NUM=$(( (RANDOM % NUM_SHORTS) + 1 ))
            RANDOM_SHORT_DATA=$(echo "$SHORTS_DATA" | sed -n "${RANDOM_LINE_NUM}p")

            # Extraer datos del short
            SHORT_URL=$(echo "$RANDOM_SHORT_DATA" | jq -r '.url')
            SHORT_DURATION=$(echo "$RANDOM_SHORT_DATA" | jq -r '.duration')
            SHORT_TITLE=$(echo "$RANDOM_SHORT_DATA" | jq -r '.title')

            # Reproducir el short
            play_video "Short Aleatorio: $SHORT_TITLE" "$SHORT_URL" "$SHORT_DURATION"
            echo "Continuando con los videos normales..."
            echo
        fi
    done

echo "¡Todos los videos del canal se han reproducido!"
