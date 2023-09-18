#!/bin/bash

main() {
    # Verify if required dependencies are present
    # If only --help flag is passed, display help message and exit
    if [[ "$1" =~ "--help" ]]; then
        hp
        exit 1
    fi
    # Check if user is in the correct directory
    { [ ! -d 'csm_web' ] || [ ! -f 'package.json' ]; } && (mecho -c red -t 'You are in the wrong directory!\n' 1>&2) && exit 1
    # Check if colima is installed, ignore if --no-colima flag is passed
    if ! (command -v colima) >/dev/null && [[ ! "$@" =~ "--no-colima" ]]; then
        (mecho -c yellow -t "Colima not found. It is reccomended to run this script with Colima. To install run: ")
        echo -e "brew install colima\n"
        echo -e -n "If you want to use this script without Colima, pass the \`--no-colima\` flag.\nThis script will then use Docker Desktop as a container runtime rather than Colima; However, Colima runs as a background process and is faster than Docker Desktop.\nIf you have already have Colima installed, restart your shell.\n"
        exit 1
    # Check if docker is installed
    elif ! (command -v docker) >/dev/null; then
        (mecho -c red -t 'You must have docker installed before running this script! (See https://www.docker.com)\n' 1>&2)
        (mecho -c yellow -t "If you don't want to install Docker Desktop, you can run: ")
        echo -e "brew install docker docker-compose"
        exit 1
    # Check if docker configuration file exists
    elif [ ! -f "$HOME"/.docker/config.json ]; then
        mecho -c yellow -t "Did not find .docker/config.json file. Start Docker Desktop for the first time, or run \`colima start\` to auto generate the file.\n"
        exit 1
    # elif ( cat "$HOME"/.docker/config.json > /dev/null | grep "credsStore" ); then
    #     sed -i '' '/"credsStore"/d' "$HOME"/.docker/config.json
    fi
    # Check if docker compose plugin symlink exists (only really important if installed with brew)
    check_compose=$(docker compose 2> >(grep -i "not"))
    if [[ $? -eq 1 ]]; then
        (mecho -c yellow -t "Docker compose plugin symlink not found. Creating one...\n")
        mkdir -p ~/.docker/cli-plugins
        ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
    fi
    # Main
    # Check if any flags are passed
    { [ $# -eq 0 ]; } && (mecho -c red -t "Required flags not found!\n") && hp && exit 1
    usedocker=0
    if [[ "$@" =~ "--no-colima" ]]; then
        { [ $# -eq 1 ]; } && mecho -c red -t "Missing flags! \`--no-colima\` requires \`--start | --kill | --reset\`\n" && hp && exit 1
        check_docker_desktop=$(ls /Applications/ | grep "Docker")
        if [[ $? -eq 1 ]]; then
            mecho -c red -t "Docker desktop is missing!\n"
            exit 1
        fi
        usedocker=1
    fi
    useforce=0
    if [[ "$@" =~ "--force" ]]; then
        useforce=1
    fi
    usereset=0
    if [[ "$@" =~ "--reset" ]]; then
        { [ $# -eq 1 ]; } && mecho -c red -t "Missing flags! \`--reset\` requires \`--kill\`\n" && hp && exit 1
        usereset=1
    fi
    for flag in "$@"; do
        case $flag in
        -s | --start) # Start
            { [ $useforce -eq 1 ]; } && mecho -c red -t "The \`--force\` flag can only be called given the \`--kill --no-colima\` flags. It is used to terminate all Docker Desktop processes.\n" && exit 1
            { [ -f up.sh.tmp ]; } && mecho -c red -t "Seems like the previous session is still running. Run ./up.sh --kill reset stale state.\n" && exit 1
            if [[ "$(docker info 2>&1)" =~ "Cannot connect to the Docker daemon" ]]; then
                (mecho -c yellow -t "Docker runtime not found. Starting...\n")
                if [[ $usedocker -eq 0 ]]; then
                    colima start
                else
                    open -gj -a "docker"
                    sleep 5
                    echo -n "flag " >>up.sh.tmp
                fi
            fi
            echo -n "1" >>up.sh.tmp
            # Check if csm_web container exists
            check_csm_web=$(docker ps -a | grep csm_web)
            if [[ $check_csm_web ]]; then
                echo "$check_csm_web" | awk '{print $1}' | xargs -I{} docker start {} 2>&1 >/dev/null
                sleep 5
            else
                docker compose up -d
            fi
            dexec python3 csm_web/manage.py createtestdata && dexec pytest csm_web
            open http://localhost:8000/admin
            (mecho -c yellow -t "To start virtual environment, run: ")
            echo -e "source \$(poetry env info --path)/bin/activate"
            tmux send-keys -t "$(tmux display-message -p '#S')" "source \$(poetry env info --path)/bin/activate && code ." C-m
            ;;
        -k | --kill) # Terminate
            if [ ! -f up.sh.tmp ]; then
                mecho -c red -t "No active docker process detected!\n"
                exit 1
            fi
            if [ "$(cat up.sh.tmp | grep -i "flag" | awk '{print $1}')" = "flag" ] && [ $usedocker -eq 0 ]; then
                mecho -c yellow -t "The \`--kill\` flag was run without the \`--no-colima\` flag on an active \`--no-colima\` session. Try ./up.sh --kill --no-colima\n"
                exit 1
            elif [ -z "$(cat up.sh.tmp | grep -i "1" | awk '{print $2}')" ] && [ $usedocker -eq 1 ]; then
                mecho -c yellow -t "The \`-kill\` flag was run with the \`--no-colima\` flag on an active colima session. Try ./up.sh --kill\n"
                exit 1
            fi
            if [ $usereset -eq 1 ]; then
                docker compose down
            else
                docker ps -a | grep csm_web | awk '{print $1}' | xargs -I{} docker stop {} 2>&1 >/dev/null
                sleep 5
            fi
            if [[ $usedocker -eq 0 ]]; then
                colima stop
            fi
            if [[ $useforce -eq 1 ]]; then
                mecho -c yellow -t "You used the \`--force\` flag, this terminates all Docker containers and processes...\n"
                ps ax | grep -i docker | egrep -iv 'grep|com.docker.vmnetd' | awk '{print $1}' | xargs kill
            fi
            rm ./up.sh.tmp
            tmux send-keys -t "$(tmux display-message -p '#S')" "deactivate" C-m
            ;;
        -r | --restart)
            if [ ! -f up.sh.tmp ]; then
                mecho -c red -t "No active docker process detected!\n"
                exit 1
            fi
            tmux send-keys -t "$(tmux display-message -p '#S')" "./up.sh --kill && ./up.sh --start" C-m
            ;;
        -L | --logs)
            docker logs \
                $(
                    docker ps -a | grep \
                        $(
                            docker ps -a --format '{{.Names}}' | grep csm_web | gum filter --placeholder "Choose container"
                        ) | awk '{print $1}'
                ) |
                bat
            ;;
        -h | --help) # Help
            hp
            ;;
        --no-colima | --force | --reset)
            # { [ $# -eq 1 ]; } && mecho -c red -t "Missing flags!\n" && hp && exit 1
            ;;
        *)
            (mecho -c red -t "Invalid flag provided!\n")
            hp
            exit 1
            ;;
        esac
    done
}

# Execute commands in CSM's docker container
dexec() {
    docker compose exec django $@
}

mecho() {
    # ANSI escape codes for text colors
    RED='\033[1;31m'
    GREEN='\033[1;32m'
    YELLOW='\033[1;33m'

    # Reset the text color to default
    RESET='\033[0m'

    # Parse command-line arguments
    while getopts ":c:t:" opt; do
        case $opt in
        c)
            case "$OPTARG" in
            red) COLOR="$RED" ;;
            green) COLOR="$GREEN" ;;
            yellow) COLOR="$YELLOW" ;;
            *)
                echo "Invalid color specified. Use 'red', 'green', or 'yellow'." >&2
                return 1
                ;;
            esac
            ;;
        t)
            TEXT="$OPTARG"
            ;;
        \?)
            echo "Usage: mecho -c {red|green|yellow} -t 'your text'"
            return 1
            ;;
        esac
    done

    # Check if both color and text are provided
    if [ -z "$COLOR" ] || [ -z "$TEXT" ]; then
        echo "Usage: mecho -c {red|green|yellow} -t 'your text'"
        return 1
    fi

    # Print the text in the specified color
    echo -e -n "${COLOR}${TEXT}${RESET}"
}

# Help
hp() {
    echo "Usage: ./up.sh [OPTION]"
    echo "Options:"
    echo "  -s | --start    [--no-colima]                       Start CSM docker runtime"
    echo "  -k | --kill     [--no-colima] [--reset] [--force]   Stop all docker runtime processes, and quit docker"
    echo "  -L | --logs                                         Display docker logs for a CSM web container"
    echo "  -r | --restart                                      Restart CSM docker runtime & containers"
    echo "  -h | --help                                         Display this help message"
}

main "$@"
