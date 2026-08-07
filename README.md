# Cloud Status Board — Junior DevOps Pet Project

Минимальный, но «боевой» пет-проект: простое веб-приложение + полный путь деплоя через базовый DevOps-стек.

**Стек:** Linux · Docker · Docker Compose · Git/GitHub · CI/CD · Nginx · Kubernetes · Terraform · Ansible · Yandex Cloud

> Цель не написать идеальный продакшен, а **понять, как куски стека стыкуются**: код → образ → локальный запуск → CI → инфраструктура → конфигурация → оркестрация в облаке.

---

## Что получится в итоге

```
Browser → Nginx → App (Python/Flask)
                 ↘ /health → {"status":"ok"}
```

Локально: `docker compose up`  
В облаке (Yandex Cloud): VM/Managed K8s поднимается Terraform’ом, настраивается Ansible, приложение крутится в Kubernetes.

---

## Архитектура (коротко)

| Слой | Инструмент | Задача |
|------|------------|--------|
| Приложение | Flask | Отдаёт HTML + healthcheck |
| Контейнеризация | Docker | Упаковываем app в образ |
| Локальный стенд | Docker Compose + Nginx | Reverse proxy перед app |
| VCS | Git + GitHub | История и PR |
| CI/CD | GitHub Actions | Lint → Build → Push image |
| IaC | Terraform | Сеть, VM/K8s в Yandex Cloud |
| Config mgmt | Ansible | Подготовка ноды / деплой |
| Оркестрация | Kubernetes | Deployment + Service + Ingress |

---

## Структура репозитория

```text
devops-pet-project/
├── app/                      # исходники приложения + Dockerfile
├── nginx/                    # конфиг reverse proxy
├── docker-compose.yml        # локальный стенд
├── .github/workflows/        # CI/CD
├── terraform/                # инфраструктура Yandex Cloud
├── ansible/                  # inventory + playbooks
├── k8s/                      # манифесты Kubernetes
├── .gitignore
└── README.md
```
## Demo (end-to-end)

1. Local: `docker compose up --build` → http://localhost/health
2. Infra: `cd terraform && terraform apply`
3. Config/deploy VM (Compose era): `ansible-playbook -i inventory/hosts.ini playbooks/site.yml`
4. K8s: k3s on VM + `kubectl apply -f k8s/` → http://<VM_IP>:30080/health
5. CI/CD: push to `main` → GHCR image → `kubectl set image ...` / `scripts/deploy.sh`

### Cleanup (не забывай про деньги)

```bash
cd terraform && terraform destroy