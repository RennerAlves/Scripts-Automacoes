#!/bin/bash

exibir_Ajuda() {
    echo -e "$(inserir_Cor amarelo)Script de Recon Web com brute de Diretórios e Arquivos$(inserir_Cor reset)"
    echo -e "$(inserir_Cor verde)Modo de usar o script:$(inserir_Cor reset) $0 $(cor azul)http://192.168.0.1$(inserir_Cor reset)"
    echo -e "$(inserir_Cor verde)Modo de usar o script:$(inserir_Cor reset) $0 $(inserir_Cor azul)http://192.168.0.0:8080$(inserir_Cor reset)"
}

verificar_Pre_Requisitos(){
    if ! command -v feroxbuster &> /dev/null; then
        echo -e "$(inserir_Cor vermelho)Erro: Feroxbuster não encontrado! Instale-o antes de executar o script.$(inserir_Cor reset)"
        exit 1
    fi
}

realizar_Brute(){
    for wordlist in $wordlists; do
        formatar_Requisicao
        echo -e "$(inserir_Cor amarelo)[+] USANDO A WORDLIST:$(inserir_Cor reset)"
        echo -e "$(inserir_Cor verde)$wordlist$(inserir_Cor reset)"
        echo""
        feroxbuster -u "$host" -w $wordlist -x .txt,.pdf,.zip,.bkp,.bak,.doc,.xls --random-agent -k
    done
}

formatar_Requisicao() {
    echo""
    echo -e "$(inserir_Cor magenta)=========== $(inserir_Cor reset)"
    echo""
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

if [ "$1" == "" ]; then
    exibir_Ajuda
    exit 1
else
    host=$1
    wordlists="/usr/share/wordlists/seclists/Discovery/Web-Content/big.txt /usr/share/wordlists/seclists/Discovery/Web-Content/raft-large-directories.txt"
    verificar_Pre_Requisitos
    realizar_Brute
fi
