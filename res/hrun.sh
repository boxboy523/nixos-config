#!/usr/bin/env bash

if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed."
    exit 1
fi

TERM_INFO=$(hyprctl activewindow -j)
TERM_ADDR=$(echo "$TERM_INFO" | jq -r '.address')
ORIGIN_WS=$(echo "$TERM_INFO" | jq -r '.workspace.name')

# 첫 번째 인자는 프로그램(onlyoffice 등)
PROGRAM=$1
shift

# 나머지 인자(파일명 등) 중 파일 경로로 보이는 것을 절대 경로로 변환
ARGS=()
for arg in "$@"; do
    # '-'로 시작하지 않고 파일이 실제로 존재한다면 절대 경로로 변환
    if [[ ! "$arg" =~ ^- ]] && [ -e "$arg" ]; then
        ARGS+=("$(realpath "$arg")")
    else
        ARGS+=("$arg")
    fi
done

# 터미널 숨기기
hyprctl dispatch movetoworkspacesilent "special:hidden,address:$TERM_ADDR"

# 프로그램 실행
$PROGRAM "${ARGS[@]}"

# 터미널 복구
hyprctl dispatch movetoworkspace "$ORIGIN_WS,address:$TERM_ADDR"
hyprctl dispatch focuswindow "address:$TERM_ADDR"
