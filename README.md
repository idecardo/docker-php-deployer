# Docker PHP Deployer

A lightweight, Alpine-based Docker image tailored for running, testing, and deploying PHP applications in CI/CD pipelines.

## Features

- **Base OS**: Alpine Linux (`php:alpine`)
- **Package Management**: Pre-installed `composer` and PIE (`pie.phar`) for PHP extension management
- **Database Drivers**: MySQL (`pdo_mysql`), PostgreSQL (`pdo_pgsql`, `libpq`), and Microsoft SQL Server (`sqlsrv`, `pdo_sqlsrv`, `msodbcsql18`)
- **Image Processing**: GD (with FreeType, JPEG, and WebP support) and ImageMagick (`imagick`)
- **Deployment Utilities**: `bash`, `openssh-client`, and `rsync` for SSH/sync deployment workflows

## Included Extensions

| Extension | Purpose | Installation Method |
| :--- | :--- | :--- |
| `bcmath` | Arbitrary-precision math | Core |
| `bz2` | Bzip2 compression | Core |
| `exif` | Image metadata parsing | Core |
| `gd` | Image processing (FreeType, JPEG, WebP) | Core |
| `gmp` | Large integer math / cryptography | Core |
| `intl` | Unicode and internationalization | Core |
| `pdo_mysql` | MySQL/MariaDB driver | Core |
| `pdo_pgsql` | PostgreSQL driver | Core |
| `zip` | ZIP archive handling | Core |
| `microsoft/sqlsrv` | SQL Server native API driver | PIE |
| `microsoft/pdo_sqlsrv` | SQL Server PDO driver | PIE |
| `imagick/imagick` | ImageMagick wrapper | PIE |

## Building Locally

To build the image locally:

```bash
docker build -t docker-php-deployer:latest .
```

## Quick Start & Verification

### Run Shell

```bash
docker run --rm -it -v $(pwd):/var/www docker-php-deployer:latest bash
```

### Verify Installed Extensions

```bash
docker run --rm docker-php-deployer:latest php -m
```

### Verify SQL Server Driver Setup

```bash
docker run --rm docker-php-deployer:latest odbcinst -q -d
```

## Contributing & Releases

For branching rules, release tagging procedures, and publishing workflows, refer to [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md).
