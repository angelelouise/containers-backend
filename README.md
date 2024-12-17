# 🚀 **LocalStack - Ambiente Local AWS com Docker Compose**

Este repositório contém um arquivo **`docker-compose.yml`** que configura o **LocalStack**, permitindo simular serviços da AWS localmente para desenvolvimento e testes.

---

## 📋 **Descrição do Projeto**

O **LocalStack** é uma ferramenta que simula serviços da AWS (como S3, DynamoDB, Lambda, entre outros) em um ambiente local, usando containers Docker. Isso permite o desenvolvimento e testes de aplicações que dependem da AWS sem custos e sem acesso à internet.

---

## 📂 **Estrutura do Projeto**

. ├── docker-compose.yml # Configuração principal do LocalStack ├── entrypoint.d/ # Scripts de inicialização para o LocalStack ├── README.md # Documentação do projeto └── volumes/ # Dados persistentes do LocalStack (montado no container)


---

## 🛠️ **Requisitos**

Antes de rodar o LocalStack, você precisa ter instalado:

1. [Docker](https://docs.docker.com/get-docker/)
2. [Docker Compose](https://docs.docker.com/compose/install/)

Verifique se estão instalados:

```bash
docker --version
docker-compose --version
```

## 🐳 **Configuração do Docker Compose**

O arquivo docker-compose.yml define os seguintes componentes:

### Serviço LocalStack

    - Imagem: localstack/localstack:latest
    - Nome do Container: localstack_main
    - Volumes:
        /var/run/docker.sock: Permite que o LocalStack execute outros containers, como lambdas.
        localstack_volume: Volume persistente para armazenar dados.
        ./entrypoint.d: Scripts customizados executados na inicialização do LocalStack.
    - Portas:
        4566:4566 → Porta principal para interagir com os serviços da AWS simulados.
        4510-4559:4510-4559 → Portas usadas para execução de Lambdas.
    - Rede:
        localstack_network → Rede bridge customizada.
    - Variáveis de Ambiente:
        DOCKER_HOST: Permite o LocalStack acessar o Docker Host.
        LAMBDA_DOCKER_NETWORK: Define a rede onde os Lambdas são executados.
    - Hosts: Adiciona a configuração host.docker.internal para referenciar o host.

## 🚀 **Como Executar**

### **1. Clone o Repositório**

```bash
git clone https://github.com/seu-usuario/seu-repositorio.git
cd seu-repositorio
```

### **2. Execute o LocalStack**

```bash
docker-compose up -d
```
O LocalStack será iniciado em modo daemon.
Verifique os logs para confirmar a inicialização:

```bash
docker logs -f localstack_main
```

## 📜 **Scripts de Inicialização**

Você pode adicionar scripts no diretório entrypoint.d. Os arquivos serão executados automaticamente após o LocalStack ser inicializado.
- Exemplo de script create-s3.sh:

```bash
#!/bin/bash
echo "Criando bucket S3 padrão..."
awslocal s3 mb s3://meu-bucket-padrao
```
Observação:

O comando awslocal é um wrapper para AWS CLI configurado para conectar-se ao LocalStack automaticamente.

## 🐳 **Parando e Limpando o Ambiente**
- Parar containers:

```bash
docker-compose down
```
- Remover volumes e redes persistentes:

```bash
docker-compose down -v
```