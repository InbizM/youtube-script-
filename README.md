# Scripts de Termux para Reproducción Automatizada en YouTube

Este proyecto contiene una serie de scripts para Termux diseñados para automatizar la reproducción de videos de un canal de YouTube en un dispositivo Android.

## Funcionalidad Principal

El script `play_channel.sh` realiza las siguientes acciones:

1.  **Prueba Inicial:** Ejecuta un video de prueba corto para verificar que la comunicación con la app de YouTube y Shizuku funciona correctamente.
2.  **Obtiene Videos:** Descarga la lista de videos y shorts del canal de YouTube especificado.
3.  **Reproducción Secuencial:** Abre y reproduce cada video normal del canal en la aplicación de YouTube.
4.  **Cierre Forzado:** Después de que la duración del video ha pasado, el script **fuerza el cierre de la aplicación de YouTube** para prepararse para el siguiente video.
5.  **Shorts Aleatorios:** Inserta un short aleatorio del mismo canal después de un número configurable de videos normales.

## Scripts

-   **`play_channel.sh`**: El script principal que ejecuta la lógica de reproducción.
-   **`setup.sh`**: Un script de instalación que configura todo lo necesario para que `play_channel.sh` funcione.
-   **`setup_shizuku.sh`**: Un script auxiliar que busca y configura la ruta para el ejecutable `rish` de Shizuku (aunque el `setup.sh` principal ya realiza una tarea similar).

## Configuración del Script

Puedes personalizar el comportamiento del script editando las siguientes variables al principio de `play_channel.sh`:

-   `CHANNEL_URL_BASE`: Cambia la URL para apuntar a tu canal de YouTube deseado.
-   `PLAY_SHORT_EVERY`: Modifica el número de videos normales que deben pasar antes de reproducir un short aleatorio.

## Instalación

Para que todo funcione, solo necesitas seguir estos pasos:

1.  **Instala y activa la aplicación de Shizuku** en tu dispositivo Android.
2.  Abre Termux y clona este repositorio o descarga los archivos.
3.  Ejecuta el script de configuración en Termux con el siguiente comando:

    ```bash
    bash setup.sh
    ```

    El script de configuración solicitará permisos de almacenamiento, creará un directorio `~/bin`, copiará los archivos de Shizuku necesarios y configurará tu archivo `.bashrc`.

4.  **Reinicia Termux** cerrando y volviendo a abrir la aplicación para que todos los cambios surtan efecto.

## Uso

Después de la instalación, puedes ejecutar el script principal en cualquier momento con:

```bash
bash play_channel.sh
```

El script comenzará con el video de prueba y luego continuará con la lista de reproducción del canal configurado.
