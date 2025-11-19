# PHP 8.1 ve Apache tabanlı resmi imajı kullanın
FROM php:8.1-apache

# Gerekli kütüphaneleri, araçları, openssh-server, supervisor, nano ve curl'u yükleyin
RUN apt-get update && apt-get install -y \
    libjpeg-dev \
    libfreetype6-dev \
    openssh-server \
    supervisor \
    nano \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Node.js 20 LTS Kurulumu (Next.js için gereklidir)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# PHP Eklentilerini Yapılandırın ve Yükleyin: gd, mysqli ve pdo_mysql
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql

# SSH Kullanıcısını Oluşturun (mahmut:1234)
RUN useradd -m mahmut && echo 'mahmut:1234' | chpasswd

# Composer'ı yükleyin
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Apache mod_rewrite modülünü etkinleştirin
RUN a2enmod rewrite

# Çalışma dizinini ayarlayın
WORKDIR /var/www/html

# PHP Ayarlarını (Yükleme Limitleri) Yükseltmek için custom.ini dosyasını kopyalayın
COPY custom.ini /usr/local/etc/php/conf.d/custom.ini

# Supervisor ve SSH için ayar dosyalarını kopyalayın
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Proje dosyalarınızı konteyner içine kopyalayın
COPY . /var/www/html

# www klasörüne 777 izni verin (chmod 777 /var/www/html)
RUN chmod 777 /var/www/html

# Composer ve NPM'i süper kullanıcı olarak çalıştırmaya izin verin
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV npm_config_allow_root=true

# Gerekli bağımlılıkları yükleyin (Hem PHP hem de Node/Next.js için)
# Eğer package.json varsa npm install çalıştırılır.
RUN if [ -f composer.json ]; then composer install; fi \
    && if [ -f package.json ]; then npm install; fi

# 80 (HTTP) ve 22 (SSH) numaralı portları dinleyin
EXPOSE 80 22

# Başlangıç komutunu Apache ve SSH'i aynı anda çalıştırmak için Supervisor ile değiştirin
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]