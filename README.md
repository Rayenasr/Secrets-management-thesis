# Secrets-management-thesis

Playbooks & script used for the thesis [*Secrets management: central management of sensitive data*](link)

## Ansible Playbooks

| Usage               | Location                                   |
| :----------------- | :------------------------------------------------------ |
| Initial Vault setup        | [installVault.yml](https://github.com/Rayenasr/Secrets-management-thesis/blob/main/vault/installVault.yml)                 |
| Create policy files        | [createPolicyFiles.yml](https://github.com/Rayenasr/Secrets-management-thesis/blob/main/vault/createPolicyFiles.yml)           |
| Update config file | [updateConfigFile.yml](https://github.com/Rayenasr/Secrets-management-thesis/blob/main/vault/updateConfigFile.yml)       |
| Fetch plugins        | [fetchPlugins.yml](https://github.com/Rayenasr/Secrets-management-thesis/blob/main/vault/fetchPlugins.yml)               |
| inventory file | [inventory](https://github.com/Rayenasr/Secrets-management-thesis/blob/main/vault/inventory) |

## Powershell script

| Usage               | GitHub gebruikersnaam                                   |
| :----------------- | :------------------------------------------------------ |
| API call to start TeamCity build        | [RunJobWithVault.ps1](https://github.com/Rayenasr/Secrets-management-thesis/blob/main/TeamCity/RunJobWithVault.ps1)                 |
