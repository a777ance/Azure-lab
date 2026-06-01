# Phase 2 — GitHub Actions Deploy Pipeline

_Draft — not yet built._

## Goal

Mirror the localDNS push-to-deploy pipeline but targeting Azure instead of SSH to t630.

## Plan

1. Create Azure service principal: `az ad sp create-for-rbac`
2. Store credentials in GitHub Actions secret `AZURE_CREDENTIALS`
3. Workflow: on push to main → `azure/login` → `az deployment group create`
4. Store sensitive params (SSH key) in Azure Key Vault, reference in Bicep

## References

- `azure/login` GitHub Action
- `azure/arm-deploy` GitHub Action
- AZ-400 exam objective: implement CI/CD pipelines for Azure
