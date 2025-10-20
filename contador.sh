#!/bin/bash

function varre_diretorios() {

#    local diretorio_origem="$1"                                           # primeiro parametro informado na hora que chamar o script

    COUNTER=0

    for dir in "$1"/*; do
        if [ -f "$dir" ]; then                                            # se for arquivo
            extensao_arquivo=$(echo $dir | cut -d"." -f2)                 # extensao
            if [ "$extensao_arquivo" == "jsp" ]; then
                COUNTER=$((COUNTER+1))
            fi
        fi
        if [ -d "$dir" ]; then                                            # se for um diretorio
            cd "$dir"
            varre_diretorios "$dir"                                       # recursividade
        fi
        cd ..
    done
    echo "Quantidade de arquivos: $COUNTER"
}


echo "Contador de arquivos"
echo "Autor: Manoel Lima <manoel.lima@manaus.am.gov.br"
echo ""
echo ""

varre_diretorios $1