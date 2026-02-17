FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# ─── System deps + PHP 8.3 + common Laravel extensions ───
RUN apt-get update && apt-get install -y \
    curl ca-certificates git wget bash sudo unzip \
    software-properties-common \
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get update && apt-get install -y \
    php8.3-cli \
    php8.3-mbstring \
    php8.3-xml \
    php8.3-curl \
    php8.3-zip \
    php8.3-bcmath \
    php8.3-intl \
    php8.3-mysql \
    php8.3-pgsql \
    php8.3-sqlite3 \
    php8.3-redis \
    php8.3-gd \
    php8.3-dom \
    php8.3-tokenizer \
    # Node (for Vite / frontend assets)
    nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# ─── Composer ───
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ─── Install Claude Code as root, copy to system path ───
RUN curl -fsSL https://claude.ai/install.sh | bash \
    && cp /root/.local/bin/claude /usr/local/bin/claude \
    && chmod +x /usr/local/bin/claude

# ─── Prepare non-root home (writable by any UID via --user flag) ───
RUN mkdir -p /home/claude/.claude && chmod -R 777 /home/claude
RUN echo '{"hasCompletedOnboarding":true}' > /home/claude/.claude.json

ENV HOME=/home/claude
WORKDIR /workspace

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
