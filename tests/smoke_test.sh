#!/bin/bash
set -e

echo "Ejecutando smoke test..."

[ -f "project.godot" ] || { echo "Falta project.godot"; exit 1; }
[ -f "export_presets.cfg" ] || { echo "Falta export_presets.cfg"; exit 1; }
[ -d "Scenes" ] || { echo "Falta la carpeta Scenes"; exit 1; }
[ -d "Scripts" ] || { echo "Falta la carpeta Scripts"; exit 1; }
[ -d "Assets" ] || { echo "Falta la carpeta Assets"; exit 1; }

echo "Smoke test completado correctamente."