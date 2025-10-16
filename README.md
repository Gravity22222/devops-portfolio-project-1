# Projeto de Portfólio DevOps: CI/CD e IaC com Azure

CI - Build and Push Docker Image(https://github.com/Gravity22222/startbootstrap-resume/actions/workflows/ci-pipeline.yml)
Release Please(https://github.com/Gravity22222/startbootstrap-resume/actions/workflows/release-please.yml)

Este projeto demonstra um ciclo de vida DevOps completo, desde a containerização de uma aplicação web até sua implantação automatizada na nuvem da Azure, utilizando práticas de CI/CD e Infraestrutura como Código (IaC).

## 🏛️ Arquitetura do Projeto


<img width="1202" height="806" alt="image" src="https://github.com/user-attachments/assets/edd2e459-c33e-4cc1-aa3f-d2aacf8468d0" />



**O fluxo funciona da seguinte maneira:**

1.  **Desenvolvedor:** Faz um `git push` para a branch `master` no GitHub.

2.  **CI/CD (GitHub Actions):**
    * O **Release Please** analisa os commits, determina a próxima versão, gera um `CHANGELOG.md` e cria uma PR de release.

    * Após o merge da PR, o **CI Pipeline** é acionado, utilizando um `Dockerfile` multi-stage para compilar a aplicação e construir uma imagem Docker otimizada.

    * A imagem Docker é enviada (push) para o **GitHub Container Registry (GHCR)** com a tag de versão correspondente.

3.  **Infraestrutura como Código (Terraform):**

    * O código Terraform é executado manualmente (ou poderia ser um pipeline de CD) para provisionar a infraestrutura na nuvem.

4.  **Nuvem (Microsoft Azure):**
    * O Terraform cria um Grupo de Recursos e uma **Azure Container Instance (ACI)**.

    * A ACI puxa (pull) a imagem de contêiner específica do GHCR e a executa, expondo o site para a internet através de uma URL pública.

## 🛠️ Tecnologias Utilizadas

* **Containerização:**
    * ![Docker](https://img.shields.io/badge/Docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
* **CI/CD (Automação):**
    * ![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

    * **GitHub Container Registry (GHCR)**

    * **Release Please** (para versionamento semântico)

* **Infraestrutura como Código (IaC):**
    * ![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
* **Nuvem:**
    * ![Microsoft Azure](https://img.shields.io/badge/Azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white) (Azure Container Instances)

## 📂 Estrutura do Repositório (Monorepo)

Este repositório está organizado como um Monorepo para manter o código da aplicação e da infraestrutura juntos.

* **/application**: Contém o código-fonte da aplicação web, o `Dockerfile` para containerização e os workflows do GitHub Actions para o pipeline de CI/CD.
* **/infrastructure**: Contém o código Terraform (`main.tf`) responsável por provisionar e gerenciar a infraestrutura na Azure.

## 🚀 Como Executar

### Pré-requisitos
* Conta no GitHub
* Conta na Microsoft Azure
* [Terraform](https://developer.hashicorp.com/terraform/downloads) instalado
* [Azure CLI](https://learn.microsoft.com/pt-br/cli/azure/install-azure-cli) instalada e autenticada (`az login`)

### 1. Processo Automatizado (CI/CD)

O pipeline de CI/CD é totalmente automatizado. Qualquer `push` na branch `master` irá:
1.  Acionar o workflow `ci-pipeline.yml` para construir e publicar a imagem Docker no GHCR.
2.  Acionar o workflow `release-please.yml` para preparar a próxima release.

### 2. Processo Manual (Deploy da Infraestrutura)

Para provisionar a infraestrutura na Azure, navegue até a pasta `/infrastructure` e execute os seguintes comandos:

1.  **Inicialize o Terraform:**
    ```bash
    cd infrastructure
    terraform init
    ```

2.  **Planeje a implantação (passo de revisão):**
    ```bash
    terraform plan \
      -var="ghcr_username=SEU_USUARIO_GITHUB" \
      -var="ghcr_pat=SEU_GITHUB_PAT"
    ```

3.  **Aplique a infraestrutura:**
    ```bash
    terraform apply \
      -var="ghcr_username=SEU_USUARIO_GITHUB" \
      -var="ghcr_pat=SEU_GITHUB_PAT"
    ```
    Confirme com `yes`. Ao final, a URL do site será exibida.

4.  **Para destruir a infraestrutura e evitar custos:**
    ```bash
    terraform destroy \
      -var="ghcr_username=SEU_USUARIO_GITHUB" \
      -var="ghcr_pat=SEU_GITHUB_PAT"
    ```
