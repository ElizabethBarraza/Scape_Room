#!/bin/bash
set -e

echo "Empaquetando build..."

mkdir -p build

if [ -d "dist/desktop" ]; then
  cd dist/desktop
  zip -r ../../build/escape-room-desktop.zip .
  cd ../..
  echo "Build desktop empaquetada en build/escape-room-desktop.zip"
elif [ -d "dist/web" ]; then
  cd dist/web
  zip -r ../../build/escape-room-web.zip .
  cd ../..
  echo "Build web empaquetada en build/escape-room-web.zip"
else
  echo "Error: no existe carpeta de exportación en dist/"
  exit 1
fi