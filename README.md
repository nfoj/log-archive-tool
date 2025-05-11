<p align="center">
	<img src="img/log-archive-tool.png">
</p>

### 💾 Simplificando o Gerenciamento de Logs Docker e Arquivos

Este projeto foi desenvolvido para otimizar e automatizar a complexa tarefa de coletar e arquivar logs de containers Docker. Com foco na eficiência, ele não apenas salva os logs com timestamps precisos em arquivos individuais, mas também rastreia o progresso para eliminar a duplicidade de dados. Para complementar sua funcionalidade principal, o projeto inclui um prático utilitário de compressão e descompressão de arquivos, acessível por um menu intuitivo, auxiliando no gerenciamento eficaz do espaço de armazenamento e na organização de outros arquivos importantes.

### 🌟 Destaques da Ferramenta:

- **Automação Inteligente:** deixe que o script cuide da coleta e organização dos logs, liberando seu tempo para outras tarefas;
- **Organização Impecável:** logs separados por container e com timestamps garantem fácil rastreabilidade e análise;
- **Eficiência de Espaço:** evita logs duplicados e oferece ferramentas de compressão para otimizar o uso do disco;
- **Simplicidade e Leveza:** uma solução em Bash, sem dependências complexas, fácil de implantar e usar;
- **Controle e Feedback Visual:** acompanhe o status e identifique problemas rapidamente com notificações coloridas no terminal.

### 🛠️ Funcionalidades Detalhadas:

#### 🪵 Monitoramento e Arquivamento de Logs do Docker (monitoring-logs.sh):

- **Monitoramento Contínuo:** verifica periodicamente os containers Docker em execução;
- **Coleta de Logs:** recupera os logs dos containers ativos com timestamps;
- **Arquivamento Organizado:** salva os logs em arquivos individuais, nomeados com o ID do container, dentro de um diretório específico;
- **Rastreamento de Timestamp:** mantém o controle do último log coletado para cada container, evitando a coleta de logs duplicados em execuções futuras;
- **Simples e Leve:** implementado em `bash`, sem dependências complexas;
- **Notificações Visuais:** utiliza cores no terminal para indicar status e possíveis erros.

#### 🗜️ Utilitário de Compressão e Descompressão (compress_tool.sh):

- **Interface de Menu Interativa:** facilita a compressão de arquivos/diretórios e a descompressão de arquivos;
- **Formatos Suportados:** `tar.gz` e `tar.bz2`
- **Operações Guiadas:** solicita os caminhos de origem e destino, com validações básicas e feedback.

### 💻 Como Começar a Usar:

#### Monitoramento de Logs ([monitoring-logs.sh](https://github.com/nfoj/log-archive-tool/blob/main/log-archive-tool/monitoring-logs.sh)):

1. **Obtenha o Script:** faça o download ou salve o código em um arquivo (ex: `monitoring-logs.sh`);
2. **Dê permissão de execução:** `chmod +x log_archive.sh`;
3. **Execute o script:** você pode executar o script em segundo plano utilizando `nohup` ou `screen`/`tmux` para que continue rodando mesmo após fechar o terminal:
    - `./log_archive.sh`
    - `nohup ./log_archive.sh &`
    - `screen -S log_archive ./log_archive.sh`
4. **Configure o diretório de logs (opcional):** edite a variável `PATH_LOG_DIR` no início do script para definir o local onde os logs serão salvos;
5. **Configure o intervalo de verificação (opcional):** altere a variável `CHECK_INTERVAL` (em segundos) para ajustar a frequência com que o script verifica os containers. 

#### Utilitário de Compressão/Descompressão ([compress_tool.sh](https://github.com/nfoj/log-archive-tool/blob/main/log-archive-tool/compression.sh)):

1. **Salve o script:** salve o script do utilitário, por exemplo: `compress_tool.sh`;
2. **Conceda Permissão de Execução:** `chmod +x compress_tool.sh`;
3. **Execute o script:** `./compress_tool.sh`;
4. **Siga as opções apresentadas no menu:** selecionar a ação (compressão/descompressão), o formato e fornecer os caminhos necessários.
