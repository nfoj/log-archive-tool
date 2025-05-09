<p align="center">
	<img src="img/log-archive-tool.png">
</p>

### 💾 Log Archive Tool - Descrição

Este script bash automatiza a coleta e o arquivamento de logs de containers Docker em execução. Ele salva os logs com timestamps em arquivos separados, rastreando o progresso para evitar duplicidade. 

### 🛠️ Funcionalidades

- **Monitoramento Contínuo:** Verifica periodicamente os containers Docker em execução.
- **Coleta de Logs:** Recupera os logs dos containers ativos com timestamps.
- **Arquivamento Organizado:** Salva os logs em arquivos individuais, nomeados com o ID do container, dentro de um diretório específico.
- **Rastreamento de Timestamp:** Mantém o controle do último log coletado para cada container, evitando a coleta de logs duplicados em execuções futuras.
- **Simples e Leve:** Implementado em `bash`, sem dependências complexas.
- **Notificações Visuais:** Utiliza cores no terminal para indicar status e possíveis erros.

### Como Usar

1. **Salve o script:** salve o código em um arquivo, por exemplo: `log_archive.sh`
2. **Dê permissão de execução:** `chmod +x log_archive.sh`
3. **Execute o script:** você pode executar o script em segundo plano utilizando `nohup` ou `screen`/`tmux` para que continue rodando mesmo após fechar o terminal:
    - `./log_archive.sh`
    - `nohup ./log_archive.sh &`
    - `screen -S log_archive ./log_archive.sh`
    
4. **Configure o diretório de logs (opcional):** Edite a variável `PATH_LOG_DIR` no início do script para definir o local onde os logs serão salvos. O padrão é `/home/user/git/developer-roadmap/projects/log-archive-tool`.
5. **Configure o intervalo de verificação (opcional):** Altere a variável `CHECK_INTERVAL` (em segundos) para ajustar a frequência com que o script verifica os containers e coleta os logs. O padrão é 60 segundos.
