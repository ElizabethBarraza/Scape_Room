#!/bin/bash
set -e

echo "Preparando despliegue web..."

if [ ! -d "dist/web" ]; then
  echo "Error: no existe dist/web"
  exit 1
fi

mkdir -p build/pages
cp -r dist/web/* build/pages/

echo "Despliegue web preparado en build/pages/"