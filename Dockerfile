# Official PHP Alpine base image
FROM php:8.5-alpine

# Prevents Composer from displaying root user warnings in CI/CD containers
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="./vendor/bin:$PATH"

# The official Composer Docker Hub image
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Install PIE (PHP Installer for Extensions)
RUN curl -fL -o /usr/local/bin/pie https://github.com/php/pie/releases/latest/download/pie.phar \
    && chmod +x /usr/local/bin/pie

# Single consolidated layer: Install runtime tools, ODBC drivers, build dependencies, compile extensions, and clean up
RUN ACCEPT_EULA=Y apk add --no-cache \
        # System CLI Tools:
        # Shell environment for running complex CI/CD deployment scripts
        bash \
        # SSH client tools (ssh, ssh-agent) for connecting to remote deploy servers
        openssh-client \
        # Differential file transfer tool used to sync code releases over SSH
        rsync \
        # C Runtime Libraries:
        # Unicode & globalization runtime library for the 'intl' extension
        icu-libs \
        # ZIP archive processing runtime library for the 'zip' extension
        libzip \
        # Bzip2 compression runtime library for the 'bz2' extension
        bzip2 \
        # GNU Multiple Precision math runtime library for the 'gmp' extension
        gmp \
        # PostgreSQL C client library required at runtime for the 'pdo_pgsql' extension
        libpq \
        # Open-source ODBC driver manager for database connectivity
        unixodbc \
        # Media & Graphics C Runtime Libraries (Required for GD & Imagick extensions):
        # Font rendering engine for drawing text onto images in GD and Imagick
        freetype \
        # High-speed JPEG image encoder/decoder for GD and Imagick
        libjpeg-turbo \
        # Portable Network Graphics (PNG) codec for GD and Imagick
        libpng \
        # Modern WebP image format compression codec for GD and Imagick
        libwebp \
        # ImageMagick C library engine used by the 'imagick' PHP extension
        imagemagick \
    # The official Microsoft C++ ODBC driver for SQL Server:
    && curl -O https://download.microsoft.com/download/ade174b7-8cea-4543-91a6-c33ae320c2f0/msodbcsql18_18.7.1.1-1_amd64.apk \
    && apk add --no-cache --allow-untrusted msodbcsql18_18.7.1.1-1_amd64.apk \
    && rm msodbcsql18_18.7.1.1-1_amd64.apk \
    # Compile-Time Dependencies, Extension Compilation & Cleanup:
    && apk add --no-cache --virtual .build-deps \
        # Temporary C/C++ Headers & Compilers (Removed after compilation to keep image small):
        # C/C++ build tools (gcc, g++, make, autoconf) required by 'pecl'
        $PHPIZE_DEPS \
        # Development headers for unixODBC required to compile sqlsrv/pdo_sqlsrv
        unixodbc-dev \
        # Development headers required to compile the 'pdo_pgsql' extension
        postgresql-dev \
        # Development headers required to compile the 'intl' extension
        icu-dev \
        # Development headers required to compile the 'zip' extension
        libzip-dev \
        # Development headers required to compile the 'bz2' extension
        bzip2-dev \
        # Development headers required to compile the 'gmp' extension
        gmp-dev \
        # Development headers required to compile GD with FreeType font support
        freetype-dev \
        # Development headers required to compile GD with JPEG image support
        libjpeg-turbo-dev \
        # Development headers required to compile GD with PNG image support
        libpng-dev \
        # Development headers required to compile GD with WebP image support
        libwebp-dev \
        # Development headers required to compile the 'imagick' PECL extension
        imagemagick-dev \
    # Configure GD Extension options prior to installation:
    && docker-php-ext-configure gd \
        # Enable FreeType font support for image text generation
        --with-freetype \
        # Enable JPEG image read/write support
        --with-jpeg \
        # Enable WebP image read/write support
        --with-webp \
    # Official PHP Core Extension Compilation:
    && docker-php-ext-install -j$(nproc) \
        # Arbitrary-precision math (prevents floating-point errors in financial math)
        bcmath \
        # High-ratio file compression using the bzip2 format
        bz2 \
        # Extracts metadata (camera specs, orientation, GPS) embedded inside photos
        exif \
        # Image manipulation library (resizing, cropping, creating thumbnails)
        gd \
        # High-performance calculation with arbitrarily large integers (cryptography)
        gmp \
        # Internationalization & localization (required by Symfony, CakePHP, CodeIgniter)
        intl \
        # PDO database driver for MySQL and MariaDB database servers
        pdo_mysql \
        # PDO database driver for PostgreSQL database servers
        pdo_pgsql \
        # ZIP extraction & creation (mandatory for Composer package downloads)
        zip \
    # Microsoft API driver interface for Microsoft SQL Server
    && pie install microsoft/sqlsrv \
    && pie install microsoft/pdo_sqlsrv \
    # Advanced image manipulation & SVG rendering
    && pie install imagick/imagick \
    # Image Cleanup:
    # Discards compiler binaries and -dev header files
    && apk del .build-deps \
    # Flushes build caches and temporary files
    && rm -rf /tmp/* /var/cache/apk/* /var/tmp/* /root/.composer /root/.pie

# Sets default working directory inside the container
WORKDIR /var/www
