#!/bin/bash

# Función para mostrar el menú
mostrar_menu() {
    echo "Selecciona una opción:"
    echo "1) Realizar respaldo de un directorio"
    echo "2) Generar informe del sistema"
    echo "3) Eliminar archivos temporales y caché"
    echo "4) Verificar e instalar actualizaciones del sistema"
    echo "5) Salir"
}

# Opción 1: Realizar respaldo de un directorio
respaldar_directorio() {
    DIRECTORIO_ORIGEN="/home/bruno"  # Cambia a tu directorio de origen
    DIRECTORIO_BACKUPS="/home/backups/backups"

    # Crear el directorio de backups si no existe
    mkdir -p "$DIRECTORIO_BACKUPS"

    # Crear el archivo de respaldo
    FECHA=$(date +"%Y%m%d_%H%M%S")
    TAR_FILE="$DIRECTORIO_BACKUPS/backup_$FECHA.tar.gz"

    echo "Iniciando respaldo..."
    tar -czf "$TAR_FILE" -C "$DIRECTORIO_ORIGEN" . 

    echo "Backup creado: $TAR_FILE"

    # Eliminar backups antiguos si hay más de 5
    cd "$DIRECTORIO_BACKUPS" || exit
    NUM_BACKUPS=$(ls -1 | wc -l)
    if [ "$NUM_BACKUPS" -gt 5 ]; then
        echo "Eliminando backups antiguos..."
        ls -1t | tail -n +6 | xargs rm -f
        echo "Backups antiguos eliminados."
    else
        echo "Número de backups dentro del límite, no se eliminaron archivos."
    fi
}

# Opción 2: Generar informe del sistema
generar_informe() {
    INFORME_FILE="/home/backups/informe_$(date +%Y%m%d_%H%M%S).log"
    echo "Generando informe del sistema..."
    echo "Uso de CPU:" > "$INFORME_FILE"
    top -bn1 | grep "Cpu(s)" >> "$INFORME_FILE"
    echo "" >> "$INFORME_FILE"
    echo "Uso de Memoria:" >> "$INFORME_FILE"
    free -h >> "$INFORME_FILE"
    echo "" >> "$INFORME_FILE"
    echo "Uso de Disco:" >> "$INFORME_FILE"
    df -h >> "$INFORME_FILE"
    echo "Informe guardado en $INFORME_FILE"
}

# Opción 3: Eliminar archivos temporales y caché
eliminar_temporales() {
    echo "Eliminando archivos temporales..."
    sudo apt-get clean
    sudo apt-get autoremove
    echo "Archivos temporales y caché eliminados."
}

# Opción 4: Verificar e instalar actualizaciones
verificar_actualizaciones() {
    echo "Verificando actualizaciones..."
    sudo apt-get update >> /home/backups/actualizaciones.log
    sudo apt-get upgrade -y >> /home/backups/actualizaciones.log
    echo "Actualizaciones instaladas. Registro en /home/backups/actualizaciones.log"
}

# Bucle principal
while true; do
    mostrar_menu
    read -p "Introduce tu elección: " OPCION

    case $OPCION in
        1) respaldar_directorio ;;
        2) generar_informe ;;
        3) eliminar_temporales ;;
        4) verificar_actualizaciones ;;
        5) exit ;;
        *) echo "Opción no válida. Intenta de nuevo." ;;
    esac
done
