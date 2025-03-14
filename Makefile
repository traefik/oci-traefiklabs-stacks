release:
	@cd proxy; zip ../proxy-stack.zip schema.yaml *.tf; cd ..
	@cd hub; zip ../hub-stack.zip schema.yaml *.tf; cd ..
	@cd hub-apim; zip ../hub-apim-stack.zip schema.yaml *.tf; cd ..
