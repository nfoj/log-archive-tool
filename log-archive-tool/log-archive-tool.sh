#!/usr/bin/env bash

# author: nfoj_@hotmail.com
# description: script for connection check
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

#!/usr/bin/env bash

# author: nfoj_@hotmail.com
# description: script for connection check
# system: arch linux
#!--------------------------------------!#
# Color
# Style          |   # Colors       | # background
# 00: none       |   # 30: black    | # 40: black
# 01: Bold       |   # 31: red      | # 41: red
# 03: Italic     |   # 32: green    | # 42: green
# 04: Underlined |   # 33: yellow   | # 43: yellow
# 05: Blinking   |   # 34: blue     | # 44: blue
# 07: Reverse    |   # 35: magenta  | # 45: magenta
# 08: Hidden     |   # 36: cyan     | # 46: cyan
#                |   # 37: white    | # 47: white
# Note:
# '\033[Style;Color;Backgroundm'
# STYLE_COLOR_BACKGROUND='\033[00;00;00m'

COLOR_BLUE='\033[1;34m'
COLOR_RED='\033[1;31m'
COLOR_YELLOW='\033[1;33m'
COLOR_GREEN='\033[1;32m'
NO_COLOR='\033[0m'

#!--------------------------------------!#

# time (seg)
CHECK_INTERVAL=60

# path
PATH_LOG_DIR="/home/user/git/developer-roadmap/projects/log-archive-tool"

# start
echo -e "${COLOR_BLUE}+-------------------------------+${NO_COLOR}"
echo -e "${COLOR_BLUE} Starting to Collect Docker Logs ${NO_COLOR}"
echo -e "${COLOR_BLUE}+-------------------------------+${NO_COLOR}"
echo -e "${COLOR_BLUE} Path:${NO_COLOR} $PATH_LOG_DIR "
echo -e "${COLOR_BLUE} Interval:${NO_COLOR} $CHECK_INTERVAL "
echo -e "${COLOR_BLUE}+-------------------------------+${NO_COLOR}"

# create folder
mkdir -p "$PATH_LOG_DIR"
if [ ! -d "$PATH_LOG_DIR" ]; then
    echo -e "${COLOR_RED}+-----------------------------------+${NO_COLOR}"
    echo -e "${COLOR_RED} [ERROR]:${NO_COLOR}"
    echo -e "${COLOR_RED} Failed to create directory:${NO_COLOR}"
    echo -e " $PATH_LOG_DIR "
    echo -e "${COLOR_RED}+-----------------------------------+${NO_COLOR}"
    exit 1
fi

#
cd "$PATH_LOG_DIR" || exit 1

#
while true; do

    echo -e "${COLOR_BLUE} Dockers Running   ${NO_COLOR}" # Y*
    echo -e "${COLOR_BLUE} [$(date '+%y-%m-%d %H:%M:%S')]   ${NO_COLOR}"
    echo -e "${COLOR_BLUE}+-------------------------------+${NO_COLOR}"

    # get the ids
    mapfile -t running_ids < <(docker ps -q --filter status=running)

    #
    if [ ${#running_ids[@]} -eq 0 ]; then
        echo " "
        echo -e "${COLOR_YELLOW}+---------------------------------+${NO_COLOR}"
        echo -e "${COLOR_YELLOW} No Running Docker Container Found ${NO_COLOR}"
        echo -e "${COLOR_YELLOW}+---------------------------------+${NO_COLOR}"
    else
        echo -e ""
        echo -e "${COLOR_YELLOW}+---------------------------------+${NO_COLOR}"
        echo -e "${COLOR_YELLOW} Containers Found: ${#running_ids[@]} ${NO_COLOR}"
        echo -e "${COLOR_YELLOW} Processing Logs ... ${NO_COLOR}"
        echo -e "${COLOR_YELLOW}+---------------------------------+${NO_COLOR}"

        #
        processed_count=0
        failed_count=0

        # mkdir > log_dir | cd log_dir > touch log_file.log ts_file.timestamp
        for docker_id in "${running_ids[@]}"; do
            short_id=$(echo "$docker_id" | cut -c1-12)
            log_dir="$short_id"
            log_file="$log_dir/$short_id.log"
            ts_file="$log_dir/$short_id.timestamp"

            # check folder
            if ! mkdir -p "$log_dir"; then
                echo -e "${COLOR_RED}+-----------------------------------+${NO_COLOR}"
                echo -e "${COLOR_RED} [ERROR]:${NO_COLOR}"
                echo -e "${COLOR_RED} Failed to create directory:${NO_COLOR}"
                echo -e "$PATH_LOG_DIR ${COLOR_RED}for container${NO_COLOR} $short_id"
                echo -e "${COLOR_YELLOW} Continuing ... ${NO_COLOR}"
                echo -e "${COLOR_RED}+-----------------------------------+${NO_COLOR}"
                continue
            fi

            since_param=""
            if [[ -f "$ts_file" ]]; then
                last_fetch_ts=$(cat "$ts_file")
                #
                if [[ -n "$last_fetch_ts" ]]; then
                    since_param="--since $last_fetch_ts"
                    echo -e "${COLOR_BLUE}+---------------------------------+${NO_COLOR}"
                    echo -e "${COLOR_BLUE} Container:${NO_COLOR} $short_id "
                    echo -e "${COLOR_BLUE} Time:${NO_COLOR} $last_fetch_ts "
                    echo -e "${COLOR_BLUE}+---------------------------------+${NO_COLOR}"
                else
                    echo -e "${COLOR_YELLOW}+---------------------------------+${NO_COLOR}"
                    echo -e "${COLOR_YELLOW} Container:${NO_COLOR} $short_id "
                    echo -e "${COLOR_YELLOW} Empty timestamp${NO_COLOR} '$ts_file' ${COLOR_YELLOW}file. Collecting all logs!${NO_COLOR}"
                    echo -e "${COLOR_YELLOW}+---------------------------------+${NO_COLOR}"
                fi
            else
                echo -e "${COLOR_YELLOW}+---------------------------------+${NO_COLOR}"
                echo -e "${COLOR_YELLOW} Container:${NO_COLOR} $short_id "
                echo -e "${COLOR_YELLOW} No previous timestamps found. Collecting all logs.${NO_COLOR}"
                echo -e "${COLOR_YELLOW}+---------------------------------+${NO_COLOR}"
            fi

            #
            current_ts=$(date -u +%Y-%m-%dT%H:%M:%S.%NZ 2>/dev/null || date -u +%Y-%m-%dT%H:%M:%SZ)

            #
            error_output=""
            if ! error_output=$(docker logs --timestamps $since_param "$docker_id" >> "$log_file" 2>&1); then
                echo -e "${COLOR_RED}+-----------------------------------+${NO_COLOR}"
                echo -e "${COLOR_RED} [ERROR]:${NO_COLOR}"
                echo -e "${COLOR_RED} Failed to collect logs for container $short_id (ID: $docker_id).${NO_COLOR}"
                echo -e "${COLOR_RED} Status: $? ${NO_COLOR}"

                #
                if [[ -n "$error_output" ]]; then
                    echo -e "${COLOR_RED} Docker error message:${NO_COLOR} $error_output "
                    echo -e "${COLOR_RED}+-----------------------------------+${NO_COLOR}"
                fi
                failed_count=$((failed_count + 1))
            else
                #
                if ! echo "$current_ts" > "$ts_file"; then
                    echo -e "${COLOR_YELLOW}+-----------------------------------+${NO_COLOR}"
                    echo -e "${COLOR_YELLOW} [Warning]:${NO_COLOR}"
                    echo -e "${COLOR_YELLOW} Failed to write timestamp to '$ts_file' for container '$short_id'.${NO_COLOR}"
                    echo -e "${COLOR_YELLOW}+-----------------------------------+${NO_COLOR}"
                fi
                #
                processed_count=$((processed_count + 1))
            fi
            #
            sleep 0.2

        done

        echo -e "${COLOR_GREEN}+-------------------------------+${NO_COLOR}"
        echo -e "${COLOR_GREEN} [LOADING]: ${NO_COLOR}"
        echo -e "${COLOR_GREEN} Completed processes:${NO_COLOR} $processed_count "
        echo -e "${COLOR_GREEN} Failures: ${NO_COLOR} $failed_count "
        echo -e "${COLOR_GREEN}+-------------------------------+${NO_COLOR}"

    # end
    fi
    echo -e "${COLOR_GREEN} [COMPLETED]: ${NO_COLOR}"
    echo -e "${COLOR_GREEN} [$(date '+%y-%m-%d %H:%M:%S')] ${NO_COLOR}"
    echo -e "${COLOR_GREEN} Waiting: "$CHECK_INTERVAL"s ${NO_COLOR}"
    echo -e "${COLOR_GREEN}+-------------------------------+${NO_COLOR}"
    sleep "$CHECK_INTERVAL"

done
echo -e "${COLOR_BLUE}+-------------------------------+${NO_COLOR}"
echo -e "${COLOR_BLUE}           Finisher!            ${NO_COLOR}"
echo -e "${COLOR_BLUE}+-------------------------------+${NO_COLOR}"
exit 0
