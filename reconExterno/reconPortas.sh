#!/bin/bash

# Função para exibir mensagem de ajuda
exibir_ajuda() {
    echo "Script de Recon inicial de portas"
    echo "Modo de usar o script: $0 192.168.0.1"
    echo "Modo de usar o script: $0 192.168.0.0/24"
    exit 1
}

# Função para realizar o escaneamento das top 1000 portas
escanear_top_1000_portas() {
    mkdir -p "/tmp/$ip"
    echo ""
    echo -e "$(inserir_Cor amarelo) [+] SCANNING - TOP 1000 PORTAS $(inserir_Cor reset)"
    nmap -v -sS --open -g 53 -Pn "$ip" | grep -E "open" | grep -v "Discovered" | grep -v "disabled"| cut -d '/' -f 1 > "/tmp/$ip/Recon1000Portas.txt"
    exibir_resultado "/tmp/$ip/Recon1000Portas.txt"
}

# Função para realizar o escaneamento de todas as portas
escanear_todas_as_portas() {
    echo ""
    echo -e "$(inserir_Cor amarelo) [+] SCANNING - TODAS AS PORTAS $(inserir_Cor reset)"
    nmap -v -sS --open -g 53 -p- -Pn "$ip" | grep -E "open" | grep -v "Discovered" | cut -d '/' -f 1 > "/tmp/$ip/ReconTodasPortas.txt"
    exibir_resultado "/tmp/$ip/ReconTodasPortas.txt"
}

# Função para realizar a análise detalhada das portas descobertas
analise_detalhada() {
    local portas=$(tr '\n' ',' < "/tmp/$ip/ReconTodasPortas.txt" | sed 's/,$//')
    echo ""
    echo -e "$(inserir_Cor amarelo) [+] SCANNING - REALIZANDO ANÁLISE DETALHADA DAS PORTAS DESCOBERTAS $(inserir_Cor reset)"
    nmap -v -sVC --open -g 53 -p "$portas" -Pn "$ip" > "/tmp/$ip/ReconDetalhadoPortas.txt"
    exibir_resultado "/tmp/$ip/ReconDetalhadoPortas.txt"
}

# Função para exibir o resultado de um arquivo
exibir_resultado() {
    local arquivo="$1"
    echo ""
    echo -e "$(inserir_Cor verde) [+] RESULTADO: $(inserir_Cor reset)"
    echo ""
    cat "$arquivo"
    echo ""
    echo "$(inserir_Cor magenta)-----------"
    echo "----------- $(inserir_Cor reset)"
    echo ""
}

inserir_Cor() {
    case "$1" in
        azul) echo -e "\e[34m" ;;
        amarelo) echo -e "\e[33m" ;;
        verde) echo -e "\e[32m" ;;
        vermelho) echo -e "\e[31m" ;;
        magenta) echo -e "\e[35m" ;;
        *) echo -e "\e[0m" ;;  # Reset se a cor for inválida
    esac
}

# Verifica se o argumento foi passado
if [ "$1" == "" ]; then
    exibir_ajuda
else
    ip="$1"
    escanear_top_1000_portas "$ip"
    escanear_todas_as_portas "$ip"
    analise_detalhada "$ip"
fi
