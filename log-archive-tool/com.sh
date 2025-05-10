#!/bin/bash

# Função para exibir o menu principal
show_main_menu() {
    clear
    echo "╔═══════════════════════════════╗"
    echo "║       Compressor de Arquivos      ║"
    echo "╠═══════════════════════════════╣"
    echo "║ 1. Comprimir Arquivo/Diretório  ║"
    echo "║ 2. Descomprimir Arquivo         ║"
    echo "║ 3. Sair                         ║"
    echo "╚═══════════════════════════════╝"
}

# Função para exibir o menu de compressão
show_compression_menu() {
    echo "╔═══════════════════════════════╗"
    echo "║         Tipo de Compressão        ║"
    echo "╠═══════════════════════════════╣"
    echo "║ 1. .tar.gz                      ║"
    echo "║ 2. .tar.bz2                     ║"
    echo "║ 3. Voltar ao Menu Principal     ║"
    echo "╚═══════════════════════════════╝"
}

# Função para exibir o menu de descompressão
show_decompression_menu() {
    echo "╔═══════════════════════════════╗"
    echo "║       Tipo de Descompressão       ║"
    echo "╠═══════════════════════════════╣"
    echo "║ 1. .tar.gz                      ║"
    echo "║ 2. .tar.bz2                     ║"
    echo "║ 3. Voltar ao Menu Principal     ║"
    echo "╚═══════════════════════════════╝"
}

# Função para comprimir arquivos
compress_file() {
    local compression_type=$1
    local source_path
    local output_filename
    local tar_options

    read -rp "Digite o caminho do arquivo/diretório para comprimir: " source_path

    if [[ -z "$source_path" ]]; then
        echo "Erro: Nenhum caminho fornecido."
        return 1
    fi

    if [[ ! -e "$source_path" ]]; then
        echo "Erro: Caminho '$source_path' não encontrado."
        return 1
    fi

    # Pega o nome base do arquivo/diretório para usar no nome do arquivo de saída
    local base_name
    base_name=$(basename "$source_path")

    case "$compression_type" in
        "tar.gz")
            output_filename="${base_name}.tar.gz"
            tar_options="-czvf"
            ;;
        "tar.bz2")
            output_filename="${base_name}.tar.bz2"
            tar_options="-cjvf"
            ;;
        *)
            echo "Erro: Tipo de compressão desconhecido."
            return 1
            ;;
    esac

    echo "Comprimindo '$source_path' para '$output_filename'..."
    # Usar -C para mudar para o diretório pai do source_path antes de comprimir
    # Isso evita que a estrutura de diretórios completa seja incluída no tarball
    # Se source_path for um arquivo, dirname será o diretório. Se for um diretório, também.
    local parent_dir
    parent_dir=$(dirname "$source_path")
    local item_to_compress
    item_to_compress=$(basename "$source_path")

    if tar "$tar_options" "$output_filename" -C "$parent_dir" "$item_to_compress"; then
        echo "Arquivo/Diretório comprimido com sucesso como '$output_filename' no diretório atual."
    else
        echo "Erro durante a compressão."
        # Tenta remover arquivo parcial se a compressão falhar
        [[ -f "$output_filename" ]] && rm "$output_filename"
        return 1
    fi
}

# Função para descomprimir arquivos
decompress_file() {
    local decompression_type=$1
    local file_to_decompress
    local output_directory
    local tar_options

    read -rp "Digite o caminho do arquivo para descomprimir: " file_to_decompress

    if [[ -z "$file_to_decompress" ]]; then
        echo "Erro: Nenhum arquivo fornecido."
        return 1
    fi

    if [[ ! -f "$file_to_decompress" ]]; then
        echo "Erro: Arquivo '$file_to_decompress' não encontrado."
        return 1
    fi

    read -rp "Digite o diretório de destino (deixe em branco para o atual): " output_directory
    output_directory=${output_directory:-.} # Define "." (diretório atual) se estiver vazio

    if [[ ! -d "$output_directory" ]]; then
        read -rp "Diretório '$output_directory' não existe. Criar? (s/N): " create_dir
        if [[ "$create_dir" =~ ^[Ss]$ ]]; then
            mkdir -p "$output_directory"
            if [[ $? -ne 0 ]]; then
                echo "Erro ao criar diretório '$output_directory'."
                return 1
            fi
        else
            echo "Descompressão cancelada."
            return 1
        fi
    fi


    case "$decompression_type" in
        "tar.gz")
            if [[ "$file_to_decompress" != *.tar.gz && "$file_to_decompress" != *.tgz ]]; then
                echo "Aviso: O arquivo não parece ser um .tar.gz. Tentando mesmo assim."
            fi
            tar_options="-xzvf"
            ;;
        "tar.bz2")
            if [[ "$file_to_decompress" != *.tar.bz2 && "$file_to_decompress" != *.tbz2 ]]; then
                 echo "Aviso: O arquivo não parece ser um .tar.bz2. Tentando mesmo assim."
            fi
            tar_options="-xjvf"
            ;;
        *)
            echo "Erro: Tipo de descompressão desconhecido."
            return 1
            ;;
    esac

    echo "Descomprimindo '$file_to_decompress' em '$output_directory'..."
    if tar "$tar_options" "$file_to_decompress" -C "$output_directory"; then
        echo "Arquivo descomprimido com sucesso em '$output_directory'."
    else
        echo "Erro durante a descompressão."
        return 1
    fi
}

# Loop principal do menu
while true; do
    show_main_menu
    read -rp "Escolha uma opção: " main_option
    echo " "

    case "$main_option" in
        1) # Compressão
            clear
            show_compression_menu
            read -rp "Escolha o tipo de compressão: " compression_option
            echo " "
            case "$compression_option" in
                1) compress_file "tar.gz" ;;
                2) compress_file "tar.bz2" ;;
                3) echo "Voltando ao menu principal..." ;;
                *) echo "Opção inválida." ;;
            esac
            ;;
        2) # Descompressão
            clear
            show_decompression_menu
            read -rp "Escolha o tipo de descompressão: " descompression_option # Corrigido: decompression_option -> descompression_option
            echo " "
            case "$descompression_option" in
                1) decompress_file "tar.gz" ;;
                2) decompress_file "tar.bz2" ;;
                3) echo "Voltando ao menu principal..." ;;
                *) echo "Opção inválida." ;;
            esac
            ;;
        3) # Sair
            echo "Saindo..."
            exit 0
            ;;
        *) # Opção inválida
            echo "Opção inválida! Tente novamente." # Corrigido: Inmvalid -> Inválida
            ;;
    esac
    echo " "
    read -rp "Pressione Enter para continuar..."
done
