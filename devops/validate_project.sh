#!/bin/bash
set -e

echo "Validando estructura del proyecto..."

if [ ! -f "project.godot" ]; then
  echo "Error: no existe project.godot"
  exit 1
fi

if [ ! -d "Scenes" ]; then
  echo "Error: no existe la carpeta Scenes"
  exit 1
fi

if [ ! -d "Scripts" ]; then
  echo "Error: no existe la carpeta Scripts"
  exit 1
fi

if [ ! -d "Assets" ]; then
  echo "Error: no existe la carpeta Assets"
  exit 1
fi

if [ ! -f "export_presets.cfg" ]; then
  echo "Error: no existe export_presets.cfg"
  echo "Debes generarlo en Godot desde Project > Export"
  exit 1
fi

if [ ! -f "tests/required_files.txt" ]; then
  echo "Error: no existe tests/required_files.txt"
  exit 1
fi

echo "Validando archivos obligatorios..."

while IFS= read -r file || [ -n "$file" ]; do
  if [ -n "$file" ] && [ ! -e "$file" ]; then
    echo "Error: falta el archivo requerido -> $file"
    exit 1
  fi
done < tests/required_files.txt

echo "Validación completada correctamente."