deploy:
	nix run nixpkgs#nixos-rebuild -- switch \
		--flake .#nixos-vm \
		--target-host junyeong@192.168.122.118 \
		--use-remote-sudo \
		--ask-sudo-password
