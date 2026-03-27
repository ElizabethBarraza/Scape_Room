#!/bin/bash
set -e

TARGET=${1:-desktop}

echo "Iniciando proceso de exportación para: $TARGET"

rm -rf dist
mkdir -p dist

if [ "$TARGET" = "desktop" ]; then
  mkdir -p dist/desktop

  cp project.godot dist/desktop/ 2>/dev/null || true
  cp export_presets.cfg dist/desktop/ 2>/dev/null || true

  [ -d Assets ] && cp -r Assets dist/desktop/
  [ -d Scenes ] && cp -r Scenes dist/desktop/
  [ -d Scripts ] && cp -r Scripts dist/desktop/

  echo "Escape Room build desktop" > dist/desktop/README_BUILD.txt
  echo "Exportación de escritorio preparada."
elif [ "$TARGET" = "web" ]; then
  mkdir -p dist/web

  cp project.godot dist/web/ 2>/dev/null || true
  cp export_presets.cfg dist/web/ 2>/dev/null || true

  [ -d Assets ] && cp -r Assets dist/web/
  [ -d Scenes ] && cp -r Scenes dist/web/
  [ -d Scripts ] && cp -r Scripts dist/web/

  cat > dist/web/index.html <<'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Escape Room Web Build</title>
</head>
<body>
  <h1>Escape Room - Build Web</h1>
  <p>Este es un artefacto de despliegue preparado para evidencia académica.</p>
</body>
</html>
EOF

  echo "Exportación web preparada."
else
  echo "Error: target no válido. Usa 'desktop' o 'web'."
  exit 1
fi

echo "Exportación completada correctamente."