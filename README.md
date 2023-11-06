[![Terraform Apply](https://github.com/fiap-postech-soat1-group21/restaurant-database/actions/workflows/terraform-apply.yml/badge.svg)](https://github.com/fiap-postech-soat1-group21/restaurant-database/actions/workflows/terraform-apply.yml)
# Software Architecture - Tech Challenge

Entrega FASE 3 - Terraform e AWS

Veja a Wiki do projeto em: https://github.com/b-bianca/soat1-challenge1/wiki


## Requisitos

|Recurso|Versão|Obrigatório|Nota|
|-|-|-|-|
|Terraform| 1.6.2|Não|Necessário apenas no caso de rodar localmente|

## Como executar o projeto localmente
Garanta que os requisitos obrigatórios estejam instalados. Após isso siga:

### Etapa 1: Inicialize o Terraform
Inicie o terraform com o seguinte comando:
~~~bash
terraform init
~~~

### Etapa 2: Executar as ações no manifesto do Terraform
Na pasta onde se encontra o arquivo iniciador, execute:
~~~bash
terraform apply
~~~

>Nota: caso já exista uma infraestrutura montada, é possível rodar o comando `terraform plan` para verificar a infra remota já existente e o que as mudanças propostas irá alterar


## Como executar o projeto pelo Github Actions
Todas as mudanças realizadas no código e mergeadas na branch `main` iniciarão a pipeline no GitHub Actions. Essa pipeline é responsável por verificar o código e realizar o deploy dos serviços na núvem de forma automática.


## Diagramas

### Criação Lambda
![image](https://github.com/fiap-postech-soat1-group21/restaurant-aws-lambda-auth/assets/83218983/905049f1-ead6-47f1-9da8-345ef2807841)

### Criação API Gateway
![image](https://github.com/fiap-postech-soat1-group21/restaurant-aws-lambda-auth/assets/83218983/a08cd434-29bb-461f-9c4b-8fee348d889c)

### Como se comunicam entre si
![image](https://github.com/fiap-postech-soat1-group21/restaurant-aws-lambda-auth/assets/83218983/ace2b1fb-92bf-4dde-8bc8-e9858c6622a8)

