info:
	docker container list -a 
	docker image list -a

build:
	docker build . -t dev

run:
	docker run -it dev bash 

clean: info 
	docker system prune -a 
	docker container list -a 
	docker images -a 

/home/vscode/.ollama:
	@echo "Creating a symlink to the LLM"
	ln -sv  /home/vscode/rag01/ollama.sav /home/vscode/.ollama  

llama3: /home/vscode/.ollama
	@echo "Time server, because it will use a cached version of the LLM"
	ollama serve 
