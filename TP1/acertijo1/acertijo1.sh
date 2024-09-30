#!/bin/bash

if [ $# -ne 2 ]; then
  echo "$0 archivo_entrada archivo_salida"
  exit 1
fi

archivo_entrada=$1
archivo_salida=$2

# Buscamos la primera hora donde Pato esté en la subsala 7,
# se resbale o se limpie las pezuñas, y los minutos sean impares
captura=$(obtener_hora_de_captura)

# Si encontramos una hora válida, la imprimimos en el archivo de salida

validar_captura(captura) 

obtener_hora_de_captura() {
  local hora_resultado = $(awk '$3 == 7 && ($5 == "resbaló" || $5 == "limpió") {
    split($2, tiempo, ":");
    if (tiempo[2] % 2 == 1) {
        print $2;
        exit;
    }
}' "$archivo_entrada")
  echo $hora_resultado
}

validar_captura() {
  if [ -n "$captura" ]; then
    echo "Hora indicada para capturar a Pato: $captura" > "$archivo_salida"
  else
    echo "No se pudo capturar a Pato." > "$archivo_salida"
  fi
}