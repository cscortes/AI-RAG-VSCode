# Check if program is already running (process name should match PROGRAM_NAME)
running := $(shell ps -C ollama | grep ollama | wc -l)

OLL_CNF=/home/vscode/.ollama
OLL_CACHE=/home/vscode/rag01/ollama.sav

# ===================================================
# for use outside of container
#

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

# ===================================================
# for use in container
#

llamasrv:
ifeq ($(running), 0)
	@echo Waiting for server to start ...
	ollama serve & 2>&1
	sleep 10 
endif

$(OLL_CACHE):
	@echo "## Making a cache for llama3"
	mkdir -p $(OLL_CACHE)

$(OLL_CNF): $(OLL_CACHE)
	@echo "## Creating a symlink to the LLM"
	ln -sv  $(OLL_CACHE) $(OLL_CNF)

llama3: $(OLL_CNF) llamasrv
	@echo "## Pulling llama3 "
	ollama pull llama3 