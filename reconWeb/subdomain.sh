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
      echo -e "$(inserir_Cor amarelo)[+] ENCONTRANDO PADRÃO DE RESPOSTA PARA DOMÍNIOS INEXISTENTES $(inserir_Cor reset)"
      tamanho_Padrao_Subdominio_Inexistente=$(encontrar_Padrao_Subdominio_Inexistente $host $porta)
      formatar_Requisicao
      echo -e "$(inserir_Cor amarelo)[+] Realizando Brute-Force de subdomínios na porta $porta $(inserir_Cor reset)"
      echo -e "$(inserir_Cor verde)Encontrado: $(inserir_Cor reset)"
      ffuf -u "http://$host:$porta" -w /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-110000.txt -H "Host: FUZZ.$host:$porta" -s -fs "$tamanho_Padrao_Subdominio_Inexistente"
      wait
   done
}

formatar_Requisicao() {
    echo ""
    echo -e "$(inserir_Cor magenta)=========== $(inserir_Cor reset)"
    echo ""
}

encontrar_Padrao_Subdominio_Inexistente(){
    cat /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt | tail -n 100 > /tmp/testeSubdominio.txt
    ffuf -u "http://$1:$2" -w /tmp/testeSubdominio.txt -H "Host: FUZZ.$1:$2" > /tmp/subdominios_inexistentes.txt
    tamanho_Padrao_Subdominio_Inexistente=$(cat /tmp/subdominios_inexistentes.txt | cut -d "," -f 2 | cut -d ":" -f 2 | sed 's/^[[:space:]]*//' | sort | uniq -c | sort -nr | head -n1 | cut -d " " -f 6)
    echo "$tamanho_Padrao_Subdominio_Inexistente"
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
