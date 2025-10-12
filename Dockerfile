FROM python:3.12-slim-bullseye

# Configurar zona horaria
ENV TZ=Europe/Madrid
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias del sistema (ODBC, compiladores y librerías gráficas para reportlab)
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Herramientas de compilación
    build-essential \
    g++ \
    # Dependencias ODBC y SSL
    unixodbc-dev \
    libmariadb-dev \
    libssl-dev \
    # Dependencias de reportlab (evita el error ft2build.h)
    libfreetype6-dev \
    libjpeg-dev \
    zlib1g-dev \
    liblcms2-dev \
    libtiff5-dev \
    libopenjp2-7-dev \
    tk-dev \
    tcl-dev \
    # Otros básicos
    curl \
    sudo \
    gnupg2 \
    dirmngr \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Configurar repositorio de Microsoft ODBC
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc > /etc/apt/trusted.gpg.d/microsoft.asc \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/microsoft.asc] https://packages.microsoft.com/debian/11/prod bullseye main" > /etc/apt/sources.list.d/mssql-release.list

# Instalar el driver msodbcsql17
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 \
    && rm -rf /var/lib/apt/lists/*

# Copiar e instalar dependencias Python
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt

# (Opcional) Instalar LibreOffice si tu aplicación genera/convierte documentos
RUN apt-get update && apt-get install -y --no-install-recommends libreoffice && rm -rf /var/lib/apt/lists/*


