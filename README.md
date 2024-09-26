# Проект на основе Docker с PHP + Nginx + MySQL и развертыванием с помощью Ansible

Этот проект настраивает простой стек LEMP (Linux, Nginx, MySQL, PHP) с использованием Docker и управляет развертыванием с помощью Ansible.


## Содержание

- [Обзор](#обзор)
- [Предварительные требования](#предварительные-требования)
- [Структура проекта](#структура-проекта)
- [Настройка и развертывание](#настройка-и-развертывание)
  - [1. Клонирование репозитория](#1-клонирование-репозитория)
  - [2. Настройка инвентаря Ansible](#2-настройка-инвентаря-ansible)
  - [3. Развертывание с помощью Ansible](#3-развертывание-с-помощью-ansible)
- [Конфигурация Docker](#конфигурация-docker)
- [Конфигурация Nginx](#конфигурация-nginx)
- [Распространенные проблемы](#распространенные-проблемы)


## Обзор

Этот проект предоставляет контейнеризированную среду для PHP-приложения с сервисами Nginx и MySQL, управляемыми Docker Compose. Он использует Ansible для автоматизации развертывания и конфигурации на удаленном веб-сервере.


## Предварительные требования

Перед запуском проекта убедитесь, что на вашем локальном компьютере установлены следующие инструменты:

- Docker (версия >= 20.10)
- Docker Compose (версия >= 1.29.2)
- Ansible (версия >= 2.10)
- Python 3


## Структура проекта

```bash
├── ansible/
│   ├── inventory                 # Инвентарь серверов для Ansible
│   ├── playbooks/
│   │   ├── site.yml              # Основной плейбук Ansible для развертывания Docker-контейнеров
│   │   └── roles/
│   │       ├── docker/           # Роль для установки и конфигурации Docker
│   │       ├── nginx/            # Роль для конфигурации Nginx
│   └── templates/
│       └── nginx.conf.j2         # Шаблон конфигурации Nginx
├── docker-compose.yml            # Файл Docker Compose для PHP, Nginx и MySQL
├── Dockerfile                    # Dockerfile для контейнера PHP
└── README.md                     # Этот файл
```


## Настройка и развертывание

### 1. Клонирование репозитория

Клонируйте репозиторий проекта на ваш локальный компьютер:

```bash
git clone <repository_url>
cd <repository_folder>
```

### 2. Настройка инвентаря Ansible

Измените файл `ansible/inventory`, чтобы включить IP-адрес вашего удаленного сервера, на который вы хотите развернуть проект. Вот пример:

```ini
[webserver]
<server_ip> ansible_user=<remote_user>
```

Замените `<server_ip>` на IP-адрес вашего сервера и `<remote_user>` на ваше имя пользователя SSH.

### 3. Развертывание с помощью Ansible

Запустите следующую команду для развертывания проекта с использованием Ansible:

```bash
ansible-playbook -i ansible/inventory ansible/playbooks/site.yml
```

Эта команда выполнит следующие действия:

- Удалит любую существующую версию `containerd.io` на сервере.
- Установит `docker.io`, `docker-compose` и `python3-pip`.
- Скопирует файлы `docker-compose.yml` и `Dockerfile` на сервер.
- Запустит сервисы с использованием Docker Compose.


## Конфигурация Docker

Основные сервисы, определенные в `docker-compose.yml`:

- **PHP**: Использует PHP 8.1 FPM (FastCGI Process Manager).
- **Nginx**: Действует как веб-сервер для обслуживания статических файлов и обратного проксирования PHP-запросов к сервису PHP FPM.
- **MySQL**: Сервис базы данных, который хранит данные приложения.

### Обзор Docker Compose

```yaml
services:
  php:
    build: .
    volumes:
      - ./src:/var/www/html
    ...
  nginx:
    ...
  mysql:
    ...
```

PHP файлы отображаются из папки `src` на хост-машине в каталог `/var/www/html` внутри контейнера PHP. Nginx использует пользовательский конфигурационный файл, предоставленный через Ansible. MySQL хранит данные в именованном томе `mysql_data`.


## Конфигурация Nginx

Ansible копирует файл конфигурации Nginx на сервер. Вот базовый обзор конфигурации:

```nginx
server {
    listen 80;
    server_name {{ server_name }};

    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ .php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass php:9000;
    }

    location ~ /.ht {
        deny all;
    }
}
```

Эта конфигурация настраивает Nginx для обработки PHP-запросов через FastCGI и обслуживания статических файлов из каталога `/var/www/html`.


## Об авторе:
Леонид Агалаков - python backend developer.
`https://github.com/Leonid-Agalakov-89`
