FROM fedora:latest as build0
RUN useradd --uid 1000 --user-group -s /bin/bash ollama && \
    echo "ollama  ALL=(ALL)   NOPASSWD: ALL"  >> /etc/sudoers
USER ollama

FROM build0 as build1
RUN sudo dnf update -y && \
    sudo dnf install -y lshw git g++ make htop procps && \
    sudo dnf install -y python3.12 python3.12-devel

FROM build1 as build2 
RUN sudo python3.12 -m ensurepip && \
    pip3.12 install --upgrade pip --user && \
    pip3.12 install langchain_nomic --user && \
    pip3.12 install -U langchain_community --user && \
    pip3.12 install -U tiktoken langchainhub chromadb --user && \
    pip3.12 install -U langgraph tavily-python --user && \
    pip3.12 install -U gpt4all langchain-text-splitters --user && \
    pip3.12 install jupyter --user 

FROM build2 as build3 

RUN sudo mkdir -p /usr/share/ollama && \
    sudo curl -fsSL https://ollama.com/install.sh | sh

RUN echo "done"

