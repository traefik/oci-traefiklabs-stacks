release:
	@bash release.sh proxy
	@bash release.sh hub
	@bash release.sh hub-apim
	@ls -lh *.zip
