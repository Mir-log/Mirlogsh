#!/bin/sh

mirror_utcnow() {
    date -u +"%Y-%m-%d %H:%M:%S UTC"
}

mirror_match_lv() {
    case "$1" in
        Info)     echo "[INFO]" ;;
        Access)   echo "[ACCESS]" ;;
        Warn)     echo "[WARN]" ;;
        Error)    echo "[ERROR]" ;;
        Panic)    echo "[PANIC]" ;;
        *)        echo "[UNKNOWN]" ;;
    esac
}

mirror_color_code() {
    case "$1" in
        green)  printf "\033[32m" ;;
        blue)   printf "\033[34m" ;;
        red)    printf "\033[31m" ;;
        white)  printf "\033[37m" ;;
        yellow) printf "\033[33m" ;;
        *)      printf "\033[0m" ;;
    esac
}

mirror_mirprint() {
    lv="$1"
    msg="$2"
    mode="$3"
    col="${4:-auto}"

    utc_str="$(mirror_utcnow)"

    case "$mode" in
        clearstrwithoutanother)
            echo "$msg"
            ;;
        timestrclear)
            echo "$utc_str $msg"
            ;;
        nocolor)
            lv_str="$(mirror_match_lv "$lv")"
            echo "$utc_str $lv_str $msg"
            ;;
        coloredstr)
            if [ "$col" = "auto" ]; then
                case "$lv" in
                    Info)   use_color="white" ;;
                    Access) use_color="green" ;;
                    Warn)   use_color="yellow" ;;
                    Error|Panic) use_color="red" ;;
                    *)      use_color="white" ;;
                esac
            else
                use_color="$col"
            fi
            color_code="$(mirror_color_code "$use_color")"
            lv_str="$(mirror_match_lv "$lv")"
            printf "%s%s %s %s\033[0m\n" "$color_code" "$utc_str" "$lv_str" "$msg"
            ;;
        *)
            echo "$utc_str [UNKNOWN] $msg"
            ;;
    esac
}

MODE_CLEARSTRWITHOUTANOTHER="clearstrwithoutanother"
MODE_TIMESTRCLEAR="timestrclear"
MODE_NOCOLOR="nocolor"
MODE_COLOREDSTR="coloredstr"

LV_INFO="Info"
LV_ACCESS="Access"
LV_WARN="Warn"
LV_ERROR="Error"
LV_PANIC="Panic"

COLOR_GREEN="green"
COLOR_BLUE="blue"
COLOR_RED="red"
COLOR_WHITE="white"
COLOR_YELLOW="yellow"
COLOR_AUTO="auto"
