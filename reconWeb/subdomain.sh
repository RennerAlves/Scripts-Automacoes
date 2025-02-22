#!/bin/bash

exibir_Ajuda() {
    echo "Script de Enumeração de Subdomínios para CTF"
    echo "Modo de usar o script: $0 DOMAIN"
    echo "E.g: $0 lookup.thm"
    exit 1
}

realizar_Brute_Subdominios() {
   for porta in $portas; do
      formatar_Requisicao
      echo -e "$(inserir_Cor amarelo)[+] Realizando Brute-Force de subdomínios na porta $porta $(inserir_Cor reset)"
      ffuf -u "http://$host:$porta" -w /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-110000.txt -H "Host: FUZZ.$host:$porta" -fc 302 -s
      wait
   done
}

formatar_Requisicao() {
    echo ""
    echo -e "$(inserir_Cor magenta)=========== $(inserir_Cor reset)"
    echo ""
}


inserir_Cor(){
    case "$1" in
        azul) echo -e "\e[34m" ;;
        amarelo) echo -e "\e[33m" ;;
        verde) echo -e "\e[32m" ;;
        vermelho) echo -e "\e[31m" ;;
        magenta) echo -e "\e[35m" ;;
        *) echo -e "\e[0m" ;;
    esac
}


if [ "$1" == "" ]; then
    exibir_Ajuda
else
    host="$1"
    portas="80 8080 443"
    realizar_Brute_Subdominios
fi
