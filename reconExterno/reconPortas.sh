#!/bin/bash

if [ "$1" == "" ]
then
    echo "Script de Recon inicial de portas"
    echo "Modo de usar o script: $0 192.168.0.1"
    echo "Modo de usar o script: $0 192.168.0.0/24"
    exit 1
else
    ip=$1
    mkdir /tmp/$ip
    echo ""
    echo "Scanning - Top 1000 portas"
    nmap -v -sS --open -g 53 -Pn $ip | grep -E "open" | grep -v "Discovered" | cut -d '/' -f 1 > /tmp/$ip/Recon1000Portas.txt
    echo ""
    echo "Portas descobertas:"
    cat /tmp/$ip/Recon1000Portas.txt
    echo ""
    echo "-----------"
    echo "-----------"
    echo ""

    echo "Scanning - Todas as portas"
    nmap -v -sS --open -g 53 -p- -Pn $ip | grep -E "open" | grep -v "Discovered" | cut -d '/' -f 1 > /tmp/$ip/ReconTodasPortas.txt
    echo ""
    echo "Portas descobertas:"
    cat /tmp/$ip/ReconTodasPortas.txt
    echo ""
    echo "-----------"
    echo "-----------"
    echo ""

    echo "Scanning - Análise detalhada"

    # Converte as portas do arquivo em uma lista separada por vírgula
    portas=$(tr '\n' ',' < /tmp/$ip/ReconTodasPortas.txt | sed 's/,$//')
    nmap -v -sVC --open -g 53 -p $portas -Pn $ip > /tmp/$ip/ReconDetalhadoPortas.txt
    echo ""
    echo "Resultado da análise detalhada:"
    cat /tmp/$ip/ReconDetalhadoPortas.txt
    echo ""
    echo "-----------"
    echo "-----------"
    echo ""
fi
