# Используем базовый образ PHP 8.1 с поддержкой FPM для запуска приложения
FROM php:8.1-fpm

# Обновляем пакеты и устанавливаем необходимые библиотеки для работы с изображениями и базой данных
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install mysqli pdo pdo_mysql

# Копируем файлы приложения в директорию контейнера
COPY ./src /var/www/html

# Устанавливаем права для файлов приложения
RUN chown -R www-data:www-data /var/www/html

# Определяем рабочую директорию контейнера
WORKDIR /var/www/html

# Запускаем PHP-FPM процесс
CMD ["php-fpm"]
