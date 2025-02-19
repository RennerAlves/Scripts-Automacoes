#!/bin/bash

if [ "$1" == "" ]; then
    echo "Script de Recon Web com brute de Diretórios e Arquivos com GOBUSTER"
    echo "Modo de usar o script: $0 http://192.168.0.1"
    echo "Modo de usar o script: $0 http://192.168.0.0:8080"
    exit 1
fi

# Verifica se o Feroxbuster está instalado
if ! command -v gobuster &> /dev/null; then
    echo "Erro: Gobuster não encontrado! Instale-o antes de executar o script."
    exit 1
fi

host=$1

echo "Iniciando o scan com Gobuster em: $host"
gobuster dir -u $host -w /usr/share/wordlists/seclists/Discovery/Web-Content/big.txt -x .txt,.pdf,.zip,.bkp,.bak,.doc,.xls,.php --random-agent -t 100
