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


## Лицензия

Учебный проект. Делай что хочешь.
