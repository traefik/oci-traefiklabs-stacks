release:
	@cd proxy; zip -q ../proxy-stack.zip schema.yaml *.tf; cd ..
	@cd hub; zip -q ../hub-stack.zip schema.yaml *.tf; cd ..
	@cd hub-apim; zip -q ../hub-apim-stack.zip schema.yaml *.tf; cd ..
	@ls -lh *.zip
