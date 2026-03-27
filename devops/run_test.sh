#!/bin/bash
set -e

echo "Iniciando pruebas del entorno de liberación..."

./tests/smoke_test.sh

echo "Todas las pruebas terminaron correctamente."