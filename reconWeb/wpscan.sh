#!/bin/bash

exibir_ajuda() {
    echo "Script de Recon inicial de portas"
    echo "Modo de usar o script: $0 http://wordpress.com"
    exit 1
}

scannear_plugins() {
    formatar_requisicao
    echo "[+] ESCANEANDO PLUGINS"
    wpscan --url "$host" --api-token XR9J6hx9FNeOj8tYsUyqMm8Rw7PAp2TSoVlgJ9oraJc --enumerate vp --plugins-detection aggressive --random-user-agent --disable-tls-checks
}

scannear_temas() {
    formatar_requisicao
    echo "[+] ESCANEANDO TEMAS"
    wpscan --url "$host" --api-token XR9J6hx9FNeOj8tYsUyqMm8Rw7PAp2TSoVlgJ9oraJc --enumerate vt --plugins-detection aggressive --random-user-agent --disable-tls-checks
}

enumerar_usuarios() {
    formatar_requisicao
    echo "[+] ENUMERANDO USUÁRIOS"
    wpscan --url "$host" --api-token XR9J6hx9FNeOj8tYsUyqMm8Rw7PAp2TSoVlgJ9oraJc --enumerate u --random-user-agent --disable-tls-checks
}

formatar_requisicao() {
    echo ""
    echo "==========="
    echo ""
}

if [ "$1" == "" ]; then
    exibir_ajuda
else
    host="$1"
    scannear_plugins
    scannear_temas
    enumerar_usuarios
fi
