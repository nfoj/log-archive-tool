#!/bin/bash



# Função para obter o nome base para o arquivo compactado
# Remove extensões comuns de arquivamento e compactação.
get_compress_basename() {
  local filename
  filename=$(basename "$1")
  # Remove .tar.gz, .tgz, .tar.bz2, .tbz2
  filename=${filename%.tar.gz}
  filename=${filename%.tgz}
  filename=${filename%.tar.bz2}
  filename=${filename%.tbz2}
  # Remove .tar se for o caso (após remover .gz ou .bz2)
  filename=${filename%.tar}
  echo "$filename"
}


# menu - main
main_menu () {
  clear
  echo "╔══════════════════════╗"
  echo "║  Compactação de Arqs ║" # Título ajustado para PT-BR
  echo "╠══════════════════════╣"
  echo "║ 1. Compactar         ║" # Ajustado para PT-BR
  echo "║ 2. Descompactar      ║" # Ajustado para PT-BR
  echo "║ 3. Sair              ║" # Ajustado para PT-BR
  echo "╚══════════════════════╝"
}

# menu - compression
menu_compression () {
  echo "╔══════════════════════╗"
  echo "║      Compactar       ║" # Ajustado para PT-BR
  echo "╠══════════════════════╣"
  echo "║ 1. tar.gz            ║"
  echo "║ 2. tar.bz2           ║"
  echo "║ 3. Voltar ao Menu    ║" # Ajustado para PT-BR
  echo "╚══════════════════════╝"
}

# menu - descompression
menu_descompression () {
  echo "╔══════════════════════╗"
  echo "║     Descompactar     ║" # Ajustado para PT-BR
  echo "╠══════════════════════╣"
  echo "║ 1. tar.gz            ║"
  echo "║ 2. tar.bz2           ║"
  echo "║ 3. Voltar ao Menu    ║" # Ajustado para PT-BR
  echo "╚══════════════════════╝"
}

# compress
compress_file () {
  local compression_type=$1
  local source_path
  local output_filename # Renomeado de output_directory para clareza
  local tar_options

  read -rp "Digite o caminho (/home/utilizador/) para compactar: " source_path # Ajustado para PT-BR

  if [[ -z "$source_path" ]]; then
    echo "Erro: nenhum caminho fornecido." # Ajustado para PT-BR
    return 1
  fi

  if [[ ! -e "$source_path"  ]]; then # Corrigido espaço extra
    echo "Erro: caminho '$source_path' não encontrado." # Ajustado para PT-BR
    return 1
  fi

  # Obter o nome base para o arquivo de saída
  local compress_basename
  compress_basename=$(get_compress_basename "$source_path")

  case "$compression_type" in
    "tar.gz")
      output_filename="${compress_basename}.tar.gz"
      tar_options="-czvf"
      ;;
    "tar.bz2")
      output_filename="${compress_basename}.tar.bz2"
      tar_options="-cjvf"
      ;;
    *)
      echo "Erro: tipo de compactação desconhecido." # Ajustado para PT-BR
      return 1
      ;;
  esac

  #
  echo "Compactando: '$source_path' para '$output_filename' " # Ajustado para PT-BR
  local parent_dir
  parent_dir=$(dirname "$source_path")
  local item_to_compress # Renomeado para clareza
  item_to_compress=$(basename "$source_path") # Corrigido: usar source_path

  # Mudar para o diretório pai para que o tar não inclua a estrutura de diretórios completa
  # e o arquivo de saída seja criado no diretório atual ou especificado.
  # Se output_filename não tiver um caminho, será criado no diretório atual.
  if tar "$tar_options" "$output_filename" -C "$parent_dir" "$item_to_compress"; then
    echo "Sucesso!" # Ajustado para PT-BR
    echo "Caminho: '$(pwd)/$output_filename'" # Mostra o caminho completo do arquivo criado
  else
    echo "Erro durante a compactação." # Ajustado para PT-BR
    [[ -f "$output_filename" ]] && rm "$output_filename"
    return 1
  fi
}

# descompress
descompression_file () {
  local descompression_type=$1
  local source_path
  local output_directory
  local tar_options

  read -rp "Digite o caminho (/home/utilizador/) para descompactar: " source_path # Ajustado para PT-BR

  if [[ -z "$source_path" ]]; then
    echo "Erro: nenhum caminho fornecido." # Ajustado para PT-BR
    return 1
  fi

  if [[ ! -f "$source_path" ]]; then # Alterado para -f para verificar se é um arquivo regular
    echo "Erro: arquivo '$source_path' não encontrado ou não é um arquivo regular." # Ajustado para PT-BR
    return 1
  fi

  read -rp "Digite o diretório de destino (deixe em branco para o atual): " output_directory # Ajustado para PT-BR
  # manter no mesmo diretório
  output_directory=${output_directory:-.} # Se vazio, define como diretório atual

  if [[ ! -d "$output_directory" ]]; then
    read -rp "Diretório '$output_directory' não existe. Criar? (s/n): " create_dir # Ajustado para PT-BR (s/n)
    if [[ "$create_dir" =~ ^[Ss]$ ]];then # Aceita 's' ou 'S'
      mkdir -p "$output_directory"
      if [[ $? -ne 0 ]]; then
        echo "Erro: Ao criar diretório '$output_directory'." # Ajustado para PT-BR
        return 1
      fi
    else
      echo "Descompactação cancelada." # Ajustado para PT-BR
      return 1
    fi
  fi

  case "$descompression_type" in
    "tar.gz")
      if [[ "$source_path" != *.tar.gz && "$source_path" != *.tgz ]];then
        echo "Aviso: O ficheiro não parece ser um .tar.gz. A tentar mesmo assim." # Ajustado para PT-BR
      fi
      tar_options="-xzvf"
      ;;
    "tar.bz2")
      # Corrigido erro de sintaxe aqui (espaço antes de ]])
      if [[ "$source_path" != *.tar.bz2 && "$source_path" != *.tbz2 ]]; then
        echo "Aviso: O ficheiro não parece ser um .tar.bz2. A tentar mesmo assim." # Ajustado para PT-BR
      fi
      tar_options="-xjvf"
      ;;
    *)
      echo "Erro: Tipo de descompactação desconhecido." # Ajustado para PT-BR
      return 1
      ;;
  esac

  #
  echo "Descompactando: '$source_path' para '$output_directory'." # Ajustado para PT-BR
  if tar "$tar_options" "$source_path" -C "$output_directory"; then # Corrigido: tar_options
    echo "Sucesso!" # Ajustado para PT-BR
    echo "Caminho: '$output_directory'" # Ajustado para PT-BR
  else
    echo "Erro durante a descompactação." # Ajustado para PT-BR
    return 1
  fi
}

# menu loop
while true; do
  main_menu
  read -rp "Digite a opção: " main_option # Ajustado para PT-BR
  echo " "

  case "$main_option" in
    1)
      # Menu - compression
      clear
      menu_compression
      read -rp "Escolha o tipo de compactação: " compression_option # Ajustado para PT-BR
      echo " "
      case "$compression_option" in
        1) compress_file "tar.gz" ;;
        2) compress_file "tar.bz2" ;;
        3) echo "A regressar ao menu!" ;; # Ajustado para PT-BR
        *) echo "Opção Inválida" ;; # Ajustado para PT-BR
      esac
      ;;
    2)
      # Menu - descompression
      clear
      menu_descompression
      read -rp "Escolha o tipo de descompactação: " descompression_option # Ajustado para PT-BR
      echo " "
      case "$descompression_option" in
        1) descompression_file "tar.gz" ;;
        2) descompression_file "tar.bz2" ;;
        3) echo "A regressar ao menu!" ;; # Ajustado para PT-BR
        *) echo "Opção Inválida" ;; # Ajustado para PT-BR
      esac
      ;;
    3)
      # close
      echo "A sair do programa!" # Ajustado para PT-BR
      exit 0
      ;;
    *)
      # invalid
      echo "Opção inválida! Por favor, tente novamente." # Ajustado para PT-BR
      ;;
  esac
  echo ""
  read -rp "Pressione Enter para continuar..." # Ajustado para PT-BR
done

