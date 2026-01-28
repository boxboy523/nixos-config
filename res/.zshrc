if [[ "$TERM" == "linux" ]]; then
    export PROMPT='%n@%m:%~%#'
else
    pokeget random
    eval "$(starship init zsh)"
    function e() {
        local TERM_INFO=$(hyprctl activewindow -j)
        local TERM_ADDR=$(echo "$TERM_INFO" | jq -r '.address')
        local ORIGIN_WS=$(echo "$TERM_INFO" | jq -r '.workspace.name')
        
        hyprctl dispatch movetoworkspacesilent "special:hidden,address:$TERM_ADDR"
        
        emacsclient -c -a '' "$@"
        
        hyprctl dispatch movetoworkspace "$ORIGIN_WS,address:$TERM_ADDR"
        hyprctl dispatch focuswindow "address:$TERM_ADDR"
    }
fi

nin() {
    nix profile add "nixpkgs#$1"
}
