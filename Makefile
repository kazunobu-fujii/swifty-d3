
BIN = ./node_modules/.bin

i:
	rm -rf node_modules
	npm install
	
install: i
	
watch: 
	@$(BIN)/webpack-dev-server --config webpack.config.js
	
serve:
	NODE_ENV=development node index.js
	
lint: 
	@$(BIN)/eslint --ext .jsx,.es --ignore-path node_modules .
	
clean:
	-rm -rf dist

.PHONY: i install clean gen serve create lint
