#!/bin/bash

exibir_Ajuda() {
    echo "Script de FFUF para requisições do tipo GET"
    echo "Modo de usar o script: $0 URL PathWordlist"
    echo "E.g: $0 http://maquina.thm/page.php?param=FUZZ rockyou.txt"
    exit 1
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

realizarAtaqueGet() {
    local url="$1"
    local wordlist="$2"

    echo ""
    echo -e "$(inserir_Cor amarelo)[+] ENCONTRANDO PADRÃO DE RESPOSTA...$(inserir_Cor reset)"
    resposta=$(encontrar_Padrao_Retorno_Inexistente "$url")

    echo ""
    echo -e "$(inserir_Cor verde)[!] PADRÃO DETECTADO: $resposta $(inserir_Cor reset)"
    echo ""

    echo -e "$(inserir_Cor amarelo)[+] INICIANDO ATAQUE COM FFUF EM $url...$(inserir_Cor reset)"
    ffuf -w "$wordlist" -u "$url" -fs "$resposta"

    echo ""
    echo -e "$(inserir_Cor verde)ATAQUE CONCLUÍDO!$(inserir_Cor reset)"
}

encontrar_Padrao_Retorno_Inexistente(){
    local url="$1"

    cat /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt | tail -n 100 > /tmp/StringsInexistentes.txt
    ffuf -u "$url" -w /tmp/StringsInexistentes.txt -mc all | grep "Size" | cut -d "," -f 2 | cut -d ":" -f 2 | tr -d " " | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}' > /tmp/PadraoFFuFGet.txt
    cat /tmp/PadraoFFuFGet.txt
}

if [ -z "$1" ] || [ -z "$2" ]; then
   exibir_Ajuda
else
   url="$1"
   wordlist="$2"
   realizarAtaqueGet "$url" "$wordlist"
fi
