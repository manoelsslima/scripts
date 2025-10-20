#!/bin/bash

function varre_diretorios() {

    local diretorio_origem="$1"                                           # primeiro parametro informado na hora que chamar o script

    prefixo_bkp="_bkp"

    for dir in "$1"/*; do
        if [ -f "$dir" ]; then                                            # se for arquivo
            extensao_arquivo=$(echo $dir | cut -d"." -f2)                 # extensao
            if [ "$extensao_arquivo" == "TXT" ]; then
                nome_arquivo_backup=${dir}${prefixo_bkp}
                iconv -f iso-8859-1 -t utf-8 $dir > $nome_arquivo_backup  # converte o encoding
                mv $nome_arquivo_backup $dir
                #sed -i '/<meta http-equiv=\"Content\-Type\" content=\"text\/html\; charset\=iso\-8859\-1\">/d' $dir
                echo "${dir}"                                             # log
            fi
        fi
        if [ -d "$dir" ]; then                                            # se for um diretorio
            cd "$dir"
            varre_diretorios "$dir"                                       # recursividade
        fi
        cd ..
    done
}


echo "=================================================="
echo "File encoding converter"
echo "Author: Manoel Lima <manoelsslima@yahoo.com.br>"
echo "=================================================="
echo ""
echo ""
echo "Arquivos modificados:"
echo ""
echo ""

varre_diretorios $1
