#!/bin/bash

exibir_Ajuda() {
    echo "Script de FFUF para requisições do tipo POST"
    echo "Modo de usar o script: $0 URL PathWordlist Data"
    echo "E.g: $0 http://maquina.thm/login.php rockyou.txt 'param1=data1&param2=FUZZ'"
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

realizarAtaquePost() {
    local url="$1"
    local wordlist="$2"
    local data="$3"

    echo ""
    echo -e "$(inserir_Cor amarelo)[+] ENCONTRANDO PADRÃO DE RESPOSTA...$(inserir_Cor reset)"
    resposta=$(encontrar_Padrao_Retorno_Inexistente "$url" "$data")

    echo ""
    echo -e "$(inserir_Cor verde)[!] PADRÃO DETECTADO: $resposta $(inserir_Cor reset)"
    echo ""

    echo -e "$(inserir_Cor amarelo)[+] INICIANDO ATAQUE COM FFUF EM $url...$(inserir_Cor reset)"
    ffuf -w "$wordlist" -X POST -d "$data" -u "$url" -fs "$resposta"

    echo ""
    echo -e "$(inserir_Cor verde)ATAQUE CONCLUÍDO!$(inserir_Cor reset)"
}

encontrar_Padrao_Retorno_Inexistente(){
    local url="$1"
    local data="$2"

    cat /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt | tail -n 100 > /tmp/StringsInexistentes.txt

    ffuf -u "$url" -X POST -w /tmp/StringsInexistentes.txt -d "$data" | grep "Size" | cut -d "," -f 2 | cut -d ":" -f 2 | tr -d " " | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}' > /tmp/RespostaInexistenteFFUF.txt

    cat /tmp/RespostaInexistenteFFUF.txt
}

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
   exibir_Ajuda
else
   url="$1"
   wordlist="$2"
   data="$3"
   realizarAtaquePost "$url" "$wordlist" "$data"
fi
