#!/bin/bash
set -e

echo "Preparando entorno DevOps..."

sudo apt-get update
sudo apt-get install -y zip unzip curl

mkdir -p build
mkdir -p dist
mkdir -p logs

echo "Entorno preparado correctamente."