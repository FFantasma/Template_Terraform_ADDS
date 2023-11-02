# Template_Terraform_ADDS

Esse código vai criar os seguintess recursos abaixo:

* Um Resource Group
* Uma Virtual Network
* Uma Subnet
* Um Network Security Group 
* Uma Azure Virtual Machine com a feature de ADDS instalado e configurado

## Implantando a infraestrutura

* Antes de rodar ps comandos em terraform, você deve se autenticar no no Azure.

```bash
# Login no Azure
az login

# Selecione a Subscription que vai usar.
az account set -S SUBSCRIPTION_NAME
```
