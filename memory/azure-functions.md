# Azure Functions

Source: AZ-204 — Automate Business Processes with Microsoft Azure (Coursera, Module 1)

---

## What it is

Serverless compute — run code in response to events without managing infrastructure.
Azure handles scaling, availability, and the underlying VM.

---

## Code-first triggers

| Trigger | Fires when | Homelab equivalent |
|---|---|---|
| `HTTPTrigger` | HTTP request arrives | A webhook or simple API |
| `TimerTrigger` | Cron schedule | Cron job on the t630 |
| `BlobTrigger` | File lands in Azure Blob Storage | inotifywait on a directory |
| `CosmosDBTrigger` | Document changes in Cosmos DB | DB change listener |

---

## vs Design-first (Logic Apps)

- **Azure Functions** = code-first, any language, full control, cheaper at scale
- **Logic Apps** = visual designer, 200+ connectors, better for non-dev workflows
- AZ-204 focuses on Functions; Logic Apps is more AZ-900/AZ-104 awareness

---

## AZ-204 exam relevance

- Implement Azure Functions (major topic)
- Choose the right trigger type for a scenario
- Durable Functions for stateful workflows (later module)
- Function App configuration: runtime, scaling, consumption vs premium plan

---

## Lab idea — TimerTrigger DNS/VPN healthcheck

Replace Uptime Kuma with a native Azure Function that:
1. Runs every 5 minutes (`0 */5 * * * *`)
2. Resolves a hostname against your DNS server
3. Pings the WireGuard endpoint
4. Writes result to Azure Monitor custom metrics
5. Triggers an alert rule if failure count > 2

This covers: Functions + Monitor + Alerts — three AZ-204 objectives in one lab.

```python
# Skeleton — TimerTrigger in Python
import azure.functions as func
import logging
import socket

app = func.FunctionApp()

@app.timer_trigger(schedule="0 */5 * * * *", arg_name="timer")
def dns_healthcheck(timer: func.TimerRequest) -> None:
    try:
        ip = socket.gethostbyname("hp-t630.homelab.internal")
        logging.info(f"DNS OK: resolved to {ip}")
    except socket.gaierror as e:
        logging.error(f"DNS FAIL: {e}")
        # TODO: write failure to Azure Monitor custom metric
```

---

## Status

- [x] Watched: Introduction, Code-first technologies
- [ ] Watched: Analyze the decision criteria
- [ ] Watched: Choose design-first technology
- [ ] Lab: Create a Function App in portal
- [ ] Lab: TimerTrigger healthcheck deployed
