FROM fedora:latest as build0
RUN useradd --uid 1000 --user-group -s /bin/bash vscode
RUN echo "vscode  ALL=(ALL)   NOPASSWD: ALL"  >> /etc/sudoers
USER vscode

FROM build0 as build1
RUN sudo dnf install -y lshw git g++ make htop && \
        sudo dnf install -y python3-pip python3-devel 

FROM build1 as build2 
RUN pip install langchain jupyter && \
    pip install -U langchain langchain_community && \
    pip install -U tiktoken langchainhub chromadb && \
    pip install -U langchain langgraph tavily-python && \
    pip install -U gpt4all langchain-text-splitters

FROM build2 as build3 
RUN sudo curl -fsSL https://ollama.com/install.sh | sh

