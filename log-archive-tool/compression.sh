#!/usr/bin/env bash

# author: nfoj_@hotmail.com
# description: script for file compression
# system: arch linux
#!--------------------------------------!#
# Color
# Style           |   # Colors       | # background
# 00: none        |   # 30: black    | # 40: black
# 01: Bold        |   # 31: red      | # 41: red
# 03: Italic      |   # 32: green    | # 42: green
# 04: Underlined  |   # 33: yellow   | # 43: yellow
# 05: Blinking    |   # 34: blue     | # 44: blue
# 07: Reverse     |   # 35: magenta  | # 45: magenta
# 08: Hidden      |   # 36: cyan     | # 46: cyan
#                 |   # 37: white    | # 47: white
# Note:
# '\033[Style;Color;Backgroundm'
# STYLE_COLOR_BACKGROUND='\033[00;00;00m'

COLOR_BLUE='\033[1;34m'
COLOR_RED='\033[1;31m'
COLOR_YELLOW='\033[1;33m'
COLOR_GREEN='\033[1;32m'
NO_COLOR='\033[0m'

#!--------------------------------------!#

# menu - main
main_menu () {
  clear
  echo "╔══════════════════════╗"
  echo "║   File Compression   ║"
  echo "╠══════════════════════╣"
  echo "║ 1. Compression       ║"
  echo "║ 2. Descompression    ║"
  echo "║ 3. Exit              ║"
  echo "╚══════════════════════╝"
}

# menu - compression
menu_compression () {  
  echo "╔══════════════════════╗"
  echo "║      Compression     ║"
  echo "╠══════════════════════╣"
  echo "║ 1. tar.gz            ║"
  echo "║ 2. tar.bz2           ║"
  echo "║ 3. menu              ║"
  echo "╚══════════════════════╝" 
}

# menu - descompression
menu_descompression () {
  echo "╔══════════════════════╗"
  echo "║    Descompression    ║"
  echo "╠══════════════════════╣"
  echo "║ 1. tar.gz            ║"
  echo "║ 2. tar.bz2           ║"
  echo "║ 3. menu              ║"
  echo "╚══════════════════════╝"
}

# compress
compress_file () {
  local compression_type=$1
  local source_path
  local output_filename
  local tar_options

  read -rp "Enter the path (/home/user/) to compression: " source_path

  if [[ -z "$source_path" ]]; then
    echo "Error: no path provided."
    return 1
  fi

  if [[ ! -e "$source_path"  ]]; then
    echo "Error: path '$source_path' not found."
    return 1
  fi

  #
  local compress_name
  compress_name=$(compressname "$source_path")

  case "$compression_type" in

    "tar.gz")
      output_filename="${compress_name}.tar.gz"
      tar_options="-czvf"
      ;;

    "tar.bz2")
      output_filename="${compress_name}.tar.bz2"
      tar_options="-cjvf"
      ;;

    *)
      echo "Error: unknown compression type."
      return 1
      ;;
      
  esac

  #
  echo "Compressing: '$source_path' for '$output_filename' "
  local parent_dir
  parent_dir=$(dirname "$source_path")
  local item_compress
  item_compress=$(basename "$source_name")

  if tar "$tar_option" "$output_filename" -C "$parent_dir" "$item_compress"; then
    echo "Sucess!"
    echo "Path: '$output_filename'"

  else
    echo "Error during compression."
    [[ -f "$output_filename" ]] && rm "$output_filename"
    return 1
  fi
}






# Menu
echo -e " "
echo "╔══════════════════════╗"
echo "║   File Compression   ║"
echo "╠══════════════════════╣"
echo "║ 1. Compression       ║"
echo "║ 2. Descompression    ║"
echo "║ 3. Exit              ║"
echo "╚══════════════════════╝"
read -p "Enter option: " main_option
echo " "

case "$main_option" in

  1)
    # Menu - compression
    echo -e " "
    echo "╔══════════════════════╗"
    echo "║      Compression     ║"
    echo "╠══════════════════════╣"
    echo "║ 1. tar.gz            ║"
    echo "║ 2. tar.bz2           ║"
    echo "╚══════════════════════╝"
    read -p "Enter option: " compression_option
    echo " "

    case "$compression_option" in

      1)
        read -p "Enter the path (/home/user/) to compression:  " file_to_compress
        tar -czvf "${file_to_compress}.tar.gz" "$file_to_compress"
        echo "File compressed to $file_to_compress.tar.gz"
        echo -e " "
        ;;

      2)
        read -p "Enter the path to compress: " file_to_compress
        tar -cjvf "${file_to_compress}.tar.bz2" "$file_to_compress"
        echo "File compressed to ${file_to_compress}.tar.bz2"
        ;;

      *)
        echo "Invalid option."
        ;;
        
    esac
    ;;

  2)
    # Menu - descompression
    echo -e " "
    echo "╔══════════════════════╗"
    echo "║    Descompression    ║"
    echo "╠══════════════════════╣"
    echo "║ 1. tar.gz            ║"
    echo "║ 2. tar.bz2           ║"
    echo "╚══════════════════════╝"
    read -p "Enter option: " descompression_option
    echo " "

    case "$decompression_option" in

      1)
        read -p "Enter the path to decompress: " file_to_decompress
        tar -xzvf "$file_to_decompress"
        cho "File decompressed."
        ;;

      2)
        read -p "Enter the path to decompress: " file_to_decompress
        tar -xjvf "$file_to_decompress"
        echo "File decompressed."
        ;;

      *)
        echo "Invalid option."
        ;;

    esac
    ;;


  3)
    echo "Exiting..."
    exit 0
    ;;

  *)
    echo "Invalid option!"
    ;;
esac
