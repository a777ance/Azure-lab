# Phase 3 — Monitoring

_Draft — not yet built._

## Goal

Replace Uptime Kuma + manual checks with Azure-native monitoring.

## Plan

- Azure Monitor alert rule: VM CPU > 80% for 5 min
- Log Analytics workspace: collect VM syslog
- Optional: keep Uptime Kuma running on VM for endpoint monitoring (it's familiar)

## AZ-104 relevance

- Configure Azure Monitor alerts
- Create Log Analytics workspace
- Configure diagnostic settings on VM
