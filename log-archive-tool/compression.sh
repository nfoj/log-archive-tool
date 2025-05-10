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

# name
compress_basename () {
  local filename
  filename=$(basename "$1")

  # remove .*
  filename=${filename%.tar.gz}
  filename=${filename%.tgz}
  filename=${filename%.tar.bz2}
  filename=${filename%.tbz2}
  filename=${filename%.tar}
  echo "$filename"
}

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

# menu - decompression
menu_decompression () {
  echo "╔══════════════════════╗"
  echo "║    Decompression     ║"
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

  if [[ ! -e "$source_path" ]]; then
    echo "Error: path '$source_path' not found."
    return 1
  fi

  #
  local compress_name
  compress_name=$(compress_basename "$source_path")

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
  item_compress=$(basename "$source_path")

  if tar "$tar_options" "$output_filename" -C "$parent_dir" "$item_compress"; then
    echo "Success!"
    echo "Path: '$(pwd)/$output_filename'"
  else
    echo "Error during compression."
    [[ -f "$output_filename" ]] && rm "$output_filename"
    return 1
  fi
}

# decompress
decompression_file () {
  local decompression_type=$1
  local source_path
  local output_directory
  local tar_options

  read -rp "Enter the path (/home/user/) to decompression: " source_path

  if [[ -z "$source_path" ]]; then
      echo "Error: no path provided."
      return 1
  fi

  if [[ ! -f "$source_path" ]]; then
      echo "Error: path '$source_path' not found."
      return 1
  fi
    
  read -rp "Enter the destination directory (leave blank for current): " output_directory
  # keep in the same directory
  output_directory=${output_directory:-.}

  if [[ ! -d "$output_directory" ]]; then
    read -rp "Directory '$output_directory' does not exist. Create? (y/n): " create_dir

    if [[ "$create_dir" =~ ^[Yy]$ ]];then
      mkdir -p "$output_directory"

      if [[ $? -ne 0 ]]; then
        echo "Error: Creating directory '$output_directory'."
        return 1
      fi

    else
      echo "Decompression cancelled."
      return 1
    fi
  
  fi

  case "$decompression_type" in

    "tar.gz")
      if [[ "$source_path" != *.tar.gz && "$source_path" != *.tgz ]];then
        echo "Warning: The file does not appear to be a .tar.gz. Trying anyway."
      fi
      tar_options="-xzvf"
      ;;

    "tar.bz2")
      if [[ "$source_path" != *.tar.bz2 && "$source_path" != *.tbz2 ]]; then
        echo "Warning: The file does not appear to be a .tar.bz2. Trying anyway."
      fi
      tar_options="-xjvf"
      ;;

    *)
      echo "Error: Unknown decompression type."
      return 1
      ;;
      
  esac

  #
  echo "Decompressing: '$source_path' for '$output_directory'."
  if tar "$tar_options" "$source_path" -C "$output_directory"; then
    echo "Success!"
    echo "Path: '$output_directory'"

  else
    echo "Error during decompression."
    return 1
  fi
}

# menu loop
while true; do
  main_menu
  read -rp "Enter option: " main_option
  echo " "

  case "$main_option" in

    1)
      # Menu - compression
      clear
      menu_compression
      read -rp "Choose the compression type: " compression_option
      echo " "
      case "$compression_option" in
        1) compress_file "tar.gz" ;;
        2) compress_file "tar.bz2" ;;
        3) echo "Return to menu!" ;;
        *) echo "Invalid Option" ;;
      esac
      ;;

    2)
      # Menu - descompression
      clear
      menu_decompression
      read -rp "Choose the decompression type" decompression_option
      echo " "
      case "$decompression_option" in
        1) decompression_file "tar.gz" ;;
        2) decompression_file "tar.bz2" ;;
        3) echo "Return to menu!" ;;
        *) echo "Invalid Option" ;;
      esac
      ;;

    3)
      # close
      echo "Leaving the program!"
      exit 0
      ;;

    *)
      # invalid
      echo "Invalid option! Please try again."
      ;;
      
  esac
  echo ""
  read -rp "Press Enter to continue..."
done
