#!/bin/bash

main () {
    # Verify if required dependencies are present
    { [ ! -d 'csm_web' ] || [ ! -f 'package.json' ]; } && ( mecho -c red -t 'You are in the wrong directory!\n' 1>&2 ) && exit 1
    if ! ( command -v colima ) > /dev/null; then
        ( mecho -c yellow -t "Colima not found. It is reccomended to run this script with Colima. To install run: " )
        echo -e "brew install colima\n"
        ( mecho -c yellow -t "If you want to use this script without Colima, pass the \`--no-colima\` flag.\nThis script will then use Docker Desktop as a container runtime rather than Colima; However, Colima runs as a background process and is faster than Docker Desktop.\nIf you have already have Colima installed, restart your shell.\n" )
        exit 1
    fi
    if ! ( command -v docker ) > /dev/null; then
        ( mecho -c red -t 'You must have docker installed before running this script! (See https://www.docker.com)\n' 1>&2 )
        exit 1
    fi
    if [ ! -f "$HOME"/.docker/config.json ]; then
        mecho -c yellow -t "Did not find .docker/config.json file. Start Docker Desktop for the first time, or run \`colima start\` to auto generate the file.\n"
        exit 1
    fi
    if ( cat "$HOME"/.docker/config.json > /dev/null | grep "credsStore" )
    then
        sed -i '' '/"credsStore"/d' "$HOME"/.docker/config.json
    fi
    # Main
    usedocker=0
    if echo "$@" | grep -q "\-\-no\-colima"; then
        { [ $# -eq 1 ]; } && ( mecho -c red -t "Missing flags!\n" ) && hp && exit 1
        usedocker=1
    fi
    { [ $# -eq 0 ]; } && ( mecho -c red -t "Required flags not found!\n" ) && hp && exit 1
    for flag in "$@"; do
        case $flag in
            --no-colima)
                { [ $# -eq 1 ]; } && ( mecho -c red -t "Missing flags!\n" ) && hp && exit 1
                ;;
            -s | --start) # Start
                { [ -f up.sh.tmp ]; } && ( mecho -c red -t "Seems like the previous session is still running. Run ./up.sh --kill to gracefully shut down all Docker processes, and run this command again.\n" ) && exit 1
                if [[ "$(docker info 2>&1)" =~ "Cannot connect to the Docker daemon" ]]; then
                    ( mecho -c yellow -t "Docker runtime not found. Starting...\n" )
                    if [[ $usedocker -eq 0 ]]; then
                        colima start
                    else
                        open -gj -a "docker"
                        sleep 5
                        echo -n "flag " >> up.sh.tmp
                    fi
                fi
                echo -n "1" >> up.sh.tmp
                docker compose up -d
                dexec python3 csm_web/manage.py createtestdata
                dexec pytest csm_web
                open http://localhost:8000/admin
                ( mecho -c yellow -t "To start virtual environment, run: " )
                echo -e "source \$(poetry env info --path)/bin/activate"
                ;;
            -k | --kill) # Terminate
                if [ ! -f up.sh.tmp ]; then
                    ( mecho -c red -t "No active docker process detected!\n" )
                    exit 1
                fi
                if [ "$(cat up.sh.tmp | grep -i "flag" | awk '{print $1}')" = "flag" ] && [ $usedocker -eq 0 ]
                then
                    mecho -c yellow -t "The \`--kill\` flag was run without the \`--no-colima\` flag on an active \`--no-colima\` session. Try ./up.sh --kill --no-colima\n"
                    exit 1
                elif [ -z "$(cat up.sh.tmp | grep -i "1" | awk '{print $2}')" ] && [ $usedocker -eq 1 ]
                then
                    mecho -c yellow -t "The \`-kill\` flag was run with the \`--no-colima\` flag on an active colima session. Try ./up.sh --kill\n"
                    exit 1
                fi
                docker compose down 
                if [ "$VIRTUAL_ENV" ]; then 
                    deactivate
                fi
                docker ps -a -q | xargs docker stop
                sleep 5
                docker ps -a -q | xargs docker rm
                sleep 5
                if [[ $usedocker -eq 0 ]]; then
                    colima stop
                elif [ $usedocker -eq 1 ] || [-f ./up.sh.tmp]; then
                    ps ax | grep -i docker | egrep -iv 'grep|com.docker.vmnetd' | awk '{print $1}' | xargs kill
                fi
                rm ./up.sh.tmp
                ;;
            -h | --help) # Help
                hp
                ;;
            *)
                ( mecho -c red -t "Invalid flag provided!\n" )
                hp
                exit 1
                ;;
        esac
    done
}

# Execute commands in CSM's docker container
dexec () {
    docker compose exec django $@ 
}

mecho () {
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
hp () {
    echo "Usage: ./up.sh [OPTION]"
    echo "Options:"
    echo "  [--no-colima] -s | --start      Start CSM docker runtime"
    echo "  [--no-colima] -k | --kill       Terminate all docker runtime processes"
    echo "  -h | --help                     Display this help message"
}

main "$@"
