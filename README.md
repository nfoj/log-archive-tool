<p align="center">
	<img src="img/log-archive-tool.png">
</p>

### 💾 Log Archive Tool - Descrição

Este projeto visa automatizar a coleta e o arquivamento de logs de containers Docker em execução. Ele salva os logs com timestamps em arquivos separados, rastreando o progresso para evitar duplicidade. Para auxiliar no gerenciamento dos dados e outros arquivos, o projeto também inclui um utilitário de compressão e descompressão de arquivos baseado em menu.

### 🛠️ Funcionalidades

#### Monitoramento de Logs do Docker:

- **Monitoramento Contínuo:** verifica periodicamente os containers Docker em execução;
- **Coleta de Logs:** recupera os logs dos containers ativos com timestamps;
- **Arquivamento Organizado:** salva os logs em arquivos individuais, nomeados com o ID do container, dentro de um diretório específico;
- **Rastreamento de Timestamp:** mantém o controle do último log coletado para cada container, evitando a coleta de logs duplicados em execuções futuras;
- **Simples e Leve:** implementado em `bash`, sem dependências complexas;
- **Notificações Visuais:** utiliza cores no terminal para indicar status e possíveis erros.

#### Utilitário de Compressão/Descompressão:

- **Interface de Menu Interativa:** facilita a compressão de arquivos/diretórios e a descompressão de arquivos;
- **Formatos Suportados:** `tar.gz` e `tar.bz2`
- **Operações Guiadas:** solicita os caminhos de origem e destino, com validações básicas e feedback.

### 💻 Como Usar

#### Monitoramento de Logs ([monitoring-logs.sh](https://github.com/nfoj/log-archive-tool/blob/main/log-archive-tool/monitoring-logs.sh)):

1. **Salve o script:** salve o código em um arquivo ou baixe o script, por exemplo: `log_archive.sh`;
2. **Dê permissão de execução:** `chmod +x log_archive.sh`;
3. **Execute o script:** você pode executar o script em segundo plano utilizando `nohup` ou `screen`/`tmux` para que continue rodando mesmo após fechar o terminal:
    - `./log_archive.sh`
    - `nohup ./log_archive.sh &`
    - `screen -S log_archive ./log_archive.sh`
4. **Configure o diretório de logs (opcional):** Edite a variável `PATH_LOG_DIR` no início do script para definir o local onde os logs serão salvos. O padrão é `/home/user/git/developer-roadmap/projects/log-archive-tool`;
5. **Configure o intervalo de verificação (opcional):** Altere a variável `CHECK_INTERVAL` (em segundos) para ajustar a frequência com que o script verifica os containers e coleta os logs. O padrão é 60 segundos.

#### Utilitário de Compressão/Descompressão ([compress_tool.sh](https://github.com/nfoj/log-archive-tool/blob/main/log-archive-tool/compression.sh)):

1. **Salve o script:** salve o script do utilitário, por exemplo: `compress_tool.sh`;
2. **Dê permissão de execução:** `chmod +x compress_tool.sh`;
3. **Execute o script:** `./compress_tool.sh`;
4. **Siga as opções apresentadas no menu:** selecionar a ação (compressão/descompressão), o formato e fornecer os caminhos necessários.
