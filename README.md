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

---

## Roadmap (делай по порядку)

Каждый этап — отдельный коммит. Не перескакивай: следующий слой опирается на предыдущий.

| # | Этап | Зачем |
|---|------|-------|
| 0 | Подготовка окружения | Инструменты и доступы |
| 1 | Приложение | Есть что деплоить |
| 2 | Docker | Повторяемый runtime |
| 3 | Docker Compose + Nginx | Локальный «мини-прод» |
| 4 | GitHub + CI | Автосборка образа |
| 5 | Terraform (YC) | Инфраструктура как код |
| 6 | Ansible | Конфиг сервера без ручных SSH-танцев |
| 7 | Kubernetes | Оркестрация и сервисная модель |
| 8 | CD / финальный прогон | Сквозной путь «commit → cloud» |

Ориентир по времени: **1–2 недели** в спокойном темпе (вечерами), не месяцы.

---

## Этап 0 — Подготовка

Установи / проверь:

- [ ] Git
- [ ] Docker Desktop (или Docker Engine + Compose)
- [ ] Python 3.11+ (для локальной проверки app без Docker — опционально)
- [ ] [Yandex Cloud CLI (`yc`)](https://yandex.cloud/ru/docs/cli/quickstart)
- [ ] Terraform >= 1.5
- [ ] Ansible (WSL / Linux / macOS удобнее, чем чистый Windows)
- [ ] `kubectl`

Создай аккаунт/облако Yandex Cloud, каталог, сервисный аккаунт с правами на Compute / VPC / Container Registry / Managed Kubernetes (по мере этапов).

---

## Этап 1 — Приложение

Создай в `app/`:

- `app.py` — Flask: `/` и `/health`
- `requirements.txt` — зависимости
- (Dockerfile появится на этапе 2)

**Критерий готовности:** `python app/app.py` → в браузере видишь страницу, `/health` отдаёт JSON.

---

## Этап 2 — Docker

Добавь `app/Dockerfile` (multi-stage не обязателен — держим просто).

**Критерий:**  
`docker build -t status-board:local ./app`  
`docker run --rm -p 8000:8000 status-board:local`  
→ `http://localhost:8000/health` = ok

---

## Этап 3 — Compose + Nginx

Файлы:

- `docker-compose.yml` — сервисы `app` + `nginx`
- `nginx/nginx.conf` — proxy_pass на `app:8000`

**Критерий:** `docker compose up --build` → открываешь `http://localhost` (порт 80), Nginx проксирует на app.

---

## Этап 4 — GitHub Actions CI

Workflow в `.github/workflows/ci.yml`:

1. checkout
2. build Docker image
3. (опционально) push в GitHub Container Registry или Yandex Container Registry

**Критерий:** push в `main` / PR → зелёный pipeline, артефакт-образ собран.

---

## Этап 5 — Terraform + Yandex Cloud

В `terraform/`:

- сеть + подсеть
- (вариант A, проще) одна VM с Docker  
- **или** (вариант B) Managed Kubernetes + Container Registry

Для Junior рекомендуется **сначала VM**, затем отдельным коммитом/этапом — Managed K8s, если останутся силы.

**Критерий:** `terraform apply` создаёт ресурсы; в outputs — IP / cluster endpoint.

---

## Этап 6 — Ansible

Playbook:

- ставит Docker (на VM) **или** ставит `kubectl`/нужные утилиты
- копирует compose/манифесты и поднимает стек

**Критерий:** один `ansible-playbook ...` приводит машину к нужному состоянию без ручного `apt install` по SSH.

---

## Этап 7 — Kubernetes

Манифесты в `k8s/`:

- `deployment.yaml`
- `service.yaml`
- `ingress.yaml` (или NodePort для упрощения)

**Критерий:** `kubectl apply -f k8s/` → поды Running, сервис отвечает на `/health`.

---

## Этап 8 — Склейка CD

Минимум: workflow по тегу/`main` пушит образ и (документированно) деплоит:

- либо `kubectl set image ...` / `kubectl apply`
- либо Ansible playbook из CI (сложнее — можно оставить полу-ручным шагом)

**Критерий:** описанный в README сценарий «изменил текст → задеплоилось» проходит end-to-end.

---

## Как работать с этим репо

1. Идёшь по этапам сверху вниз.
2. В чате/с ментором берёшь **готовый блок кода** → вставляешь в файл → запускаешь команду проверки.
3. После каждого этапа: `git add` → `git commit` с понятным сообщением (`feat: dockerize flask app`).
4. Если что-то падает — чини **понимание** (логи контейнера, `terraform plan`, `kubectl describe`), а не «перепиши всё».

---

## Полезные команды (шпаргалка)

```bash
# Local
docker compose up --build
docker compose logs -f
curl http://localhost/health

# Terraform
cd terraform && terraform init && terraform plan && terraform apply

# Ansible
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/site.yml

# K8s
kubectl apply -f k8s/
kubectl get pods,svc,ingress
kubectl logs deploy/status-board
```

---

## Что писать в резюме / README итога

> Поднял pet-проект: контейнеризировал Flask-приложение, собрал локальный стенд на Docker Compose + Nginx, настроил CI в GitHub Actions, описал инфраструктуру в Yandex Cloud через Terraform, автоматизировал конфигурацию Ansible и задеплоил в Kubernetes.

Этого достаточно, чтобы на собесе Junior/Middle− уверенно разбирать каждый слой.

---

## Лицензия

Учебный проект. Делай что хочешь.
