# Desafio IDWall - Kubernetes

## Processo kubernetes
* Primeiro passo: criar namespace
* Segundo passo: Criar serviço
* Terceiro passo: Criar deployment
* Quarto passo: Criar ingress

## Utilização

### Requisitos:
    - Binário kubectl presente na maquina e no PATH do sistema operacional
    - Arquivo de configuração do kubectl presente no perfil do usuário (~/.kube/config)

### Como utilizar
    - Para criação do POD basta executar o script kubernetes/deploy.sh
      - Será criado após a execução do script:
        * Namespace
        * Service
        * Deployment
        * Ingress
        
### Acesso
    - Acessar a aplicação NodeJS atraves do endereço http://<ip_ou_url_de_acesso_ao_ingress>:3000

### Saida padrão:    
> Olá Desafio DevOps (feito por Kelson)!