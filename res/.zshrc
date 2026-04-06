if [[ "$TERM" == "linux" ]]; then
    export PROMPT='%n@%m:%~%#'
else
    pokeget random
    eval "$(starship init zsh)"
    alias ok='hrun okular'
    alias e="hrun emacsclient -c -a \'\'"
    function oo() {
    # 인자가 없으면 프로그램만 실행
    if [ $# -eq 0 ]; then
        hrun onlyoffice-desktopeditors
        return
    fi

    # 마지막 인자를 파일명으로 추출
    local filename="${@: -1}"
    # 마지막 인자를 제외한 나머지를 옵션으로 추출
    local options=("${@:1:$# - 1}")

    # 파일이 존재하면 절대 경로로 변환 (realpath)
    if [ -e "$filename" ]; then
        filename=$(realpath "$filename")
    fi

    # hrun을 사용하여 실행
    hrun onlyoffice-desktopeditors "${options[@]}" "--view=$filename"
}
fi

nin() {
    nix profile add "nixpkgs#$1"
}
