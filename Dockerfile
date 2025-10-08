FROM python:3.12-slim-bullseye

# Configurar zona horaria
ENV TZ=Europe/Madrid
RUN apt-get update && apt-get install -y tzdata && rm -rf /var/lib/apt/lists/*

# Instalar dependencias esenciales (incluyendo gnupg2 completo)
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    unixodbc-dev \
    g++ \
    libmariadb-dev \
    libssl-dev \
    gnupg2 \
    dirmngr \
    && rm -rf /var/lib/apt/lists/*

# Configurar repositorio Microsoft ODBC (método actualizado)
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc > /etc/apt/trusted.gpg.d/microsoft.asc \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/microsoft.asc] https://packages.microsoft.com/debian/11/prod bullseye main" > /etc/apt/sources.list.d/mssql-release.list

# Instalar msodbcsql17
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 \
    && rm -rf /var/lib/apt/lists/*
# Instalar dependencias de Python
COPY requirements.txt ./
RUN pip install --upgrade pip \
    && pip install -r requirements.txt
RUN apt-get update && apt-get install -y \
    libreoffice \
    && rm -rf /var/lib/apt/lists/*