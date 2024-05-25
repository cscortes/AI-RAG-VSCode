FROM fedora:latest as build0
RUN useradd --uid 1000 --user-group -s /bin/bash vscode && \
    echo "vscode  ALL=(ALL)   NOPASSWD: ALL"  >> /etc/sudoers
USER vscode

FROM build0 as build1
RUN sudo dnf update -y && \
    sudo dnf install -y lshw git g++ make htop procps && \
    sudo dnf install -y python3.12 python3.12-devel

FROM build1 as build2 
RUN sudo python3.12 -m ensurepip && \
    sudo pip3.12 install --upgrade pip && \
    sudo pip3.12 install langchain_nomic && \
    sudo pip3.12 install -U langchain_community && \
    sudo pip3.12 install -U tiktoken langchainhub chromadb && \
    sudo pip3.12 install -U langgraph tavily-python && \
    sudo pip3.12 install -U gpt4all langchain-text-splitters && \
    sudo pip3.12 install jupyter

FROM build2 as build3 

RUN sudo mkdir -p /usr/share/ollama && \
    sudo useradd --user-group -s /bin/bash ollama && \
    sudo curl -fsSL https://ollama.com/install.sh | sh

RUN echo "done"

