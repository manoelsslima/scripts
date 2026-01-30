#!/usr/bin/env bash

#######################################################################################
# Conversor de encoding de iso-8859-1 para utf-8
#
# Uso:
# converter todos os arquivos java do diretório atual:
# $ ./conversor.sh java
#
# converter todos os arquivos CSS de um diretório específico:
# $ ./conversor.sh css /tmp/files
#
# converter todos os arquivos typescript recursivamente:
# $ ./conversor.sh ts .
#######################################################################################

# Extensão a ser convertida (obrigatória)
EXTENSION="$1"

# Diretório raiz (opcional, default: diretório atual)
ROOT_DIR="${2:-.}"

# Validação do argumento obrigatório
if [ -z "$EXTENSION" ]; then
  echo "Uso: $0 <extensao> [diretorio]"
  echo "Exemplo: $0 java /caminho/do/projeto"
  exit 1
fi

# Verifica dependência
command -v iconv >/dev/null 2>&1 || {
  echo "Erro: iconv não está instalado."
  exit 1
}

echo "Extensão: .$EXTENSION"
echo "Diretório: $ROOT_DIR"
echo "Conversão: ISO-8859-1 -> UTF-8"
echo "Backup: prefixo bkp_"
echo

find "$ROOT_DIR" -type f -name "*.${EXTENSION}" | while IFS= read -r file; do
  dir="$(dirname "$file")"
  base="$(basename "$file")"
  backup="$dir/bkp_$base"
  tmp="$(mktemp)"

  # Cria backup apenas uma vez
  if [ ! -f "$backup" ]; then
    cp "$file" "$backup"
  fi

  # Converte encoding
  if iconv -f ISO-8859-1 -t UTF-8 "$file" -o "$tmp"; then
    mv "$tmp" "$file"
    echo "✔ Convertido: $file"
  else
    echo "✖ Erro ao converter: $file"
    rm -f "$tmp"
  fi
done

echo
echo "Processo finalizado."
