## Inhaltsverzeichnis

1. [Repository klonen und Branch wechseln](#1-repository-klonen-und-branch-wechseln)  
2. [Entwicklungsumgebung konfigurieren](#2-entwicklungsumgebung-konfigurieren)  
3. [Docker starten](#3-docker-starten)  
4. [Im Docker-Container arbeiten](#4-im-docker-container-arbeiten)  
5. [Rails Server starten](#5-rails-server-starten)  
6. [User anlegen](#6-user-anlegen)  
7. [Tests ausführen](#7-tests-ausführen)  
8. [Produktivumgebung konfigurieren](#8-produktivumgebung-konfigurieren)  
9. [Weitere Befehle](#9-weitere-befehle)  

## 1. Repository klonen und Branch wechseln

Klone das Projekt:

```bash
git clone git@github.com:nocheatoriginal/exproware.git
cd app
```

## 2. Entwicklungsumgebung konfigurieren

Die Anmeldedaten für den E-Mail-Versand müssen hinterlegt werden.
1. Erstelle im Projektverzeichnis eine Neue Datei `.env`. Hier werden lokale Umgebungsvariablen hinterlegt.
2. Öffne die `.env`-Datei und füge folgende Variablen ein:

```env
SMTP_USERNAME=replace_with_your_smtp_username
SMTP_PASSWORD=replace_with_your_smtp_password
```

In der `config/evironments/production.rb` müssen unter Umständen die folgenden Werte angepasst werden:
```ruby
config.action_mailer.smtp_settings = {
    address: 'smtp.strato.de',      # SMTP Adresse anpassen
    port: 587,                      # SMTP Port anpassen
    domain: ENV['DOMAIN_NAME'],
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication: 'plain',
    enable_starttls_auto: true
  }
```


## 3. Docker starten

Stelle sicher, dass Docker läuft, bevor du fortfährst. Hier sind Anweisungen für verschiedene Betriebssysteme:

```bash
# MacOS:
open -a Docker

# Linux:
sudo systemctl start docker

# Windows: Docker Desktop öffnen
```

## 4. Im Docker-Container arbeiten

Um eine interaktive Shell im Docker-Container zu öffnen und im Projekt zu arbeiten, führe folgenden Befehl aus: 'docker compose run app fish'

## 5. Rails Server starten

Zum Starten des Rails-Servers für die lokale Entwicklung, führe diesen Befehl aus: 'docker compose up'

## 6. User anlegen über die Rails-Konsole

Stelle sicher, dass du dich in der interaktiven Shell befindest: 'docker compose run app fish'
Verwende die 'rails console'

```bash
User.create!(email: 'admin@email.de', password: '1234567890', password_confirmation: '1234567890', role: :admin)
```

## 7. Tests ausführen

Stelle sicher, dass du dich in der interaktiven Shell befindest: 'docker compose run app fish'

```bash
# Unit Tests:
rails test

# System Tests:
rails test:system
```

## 8. Produktivumgebung konfigurieren

1. Erstelle im Projektverzeichnis eine Neue Datei `.env`. Hier werden lokale Umgebungsvariablen hinterlegt.
2. Öffne die `.env`-Datei und füge folgende Variablen ein:
3. Zuvor muss ein geheimer Schlüssel und ein SSL Zertifikat erstellt werden:
    - SECRET_KEY_BASE muss per `rails secret` generiert werden. Das geheime Schlüssel muss dann anschließend in die `.env`-Datei eingefügt werden
    - Der Pfad zum SSL-Schlüssel (SSL_KEY_PATH) und zum SSL-Zertifikat (SSL_CERT_PATH) müssen ebenfalls zur `.env`-Datei hinzugefügt werden

```env
POSTGRES_USER=replac_with_your_posgres_user
POSTGRES_PASSWORD=replac_with_your_posgres_user
POSTGRES_DB=replac_with_your_posgres_db_name
DATABASE_HOST=db
DATABASE_URL=postgres://replac_with_your_posgres_user:replac_with_your_posgres_user@db:5432/replac_with_your_posgres_db_name
DATABASE_USERNAME=replac_with_your_posgres_user
DATABASE_PASSWORD=replac_with_your_posgres_user
SMTP_USERNAME=replac_with_your_smpt_username
SMTP_PASSWORD=replac_with_your_smpt_password
DOMAIN_NAME=replace_with_your_domain
RAILS_ENV=production
SECRET_KEY_BASE=replace_with_your_secret_key_base
SSL_KEY_PATH=replace_with_path_to_your_ssl_key
SSL_CERT_PATH=replace_with_path_to_your_ssl_certificate
```

Die `docker-compose.yml`-Datei muss auch angepasst werden:
```docker-compose
services:
  app:
    build: .
    ports:
      - "127.0.0.1:3000:3000"
    volumes:
      - ./:/app
    command: bash -c "bundle exec rails db:prepare && bundle exec rails server -b 0.0.0.0"
    depends_on:
      db:
        condition: service_healthy
    environment:
      - RAILS_ENV
      - SECRET_KEY_BASE
      - DATABASE_HOST
      - DATABASE_USERNAME
      - DATABASE_PASSWORD
      - DATABASE_URL
      - SMTP_USERNAME
      - SMTP_PASSWORD
      - SSL_KEY_PATH
      - SSL_CERT_PATH
    command: rails s -b 'ssl://0.0.0.0:3000?key=${SSL_KEY_PATH}&cert=${SSL_CERT_PATH}&verify_mode=none&ca=${SSL_CERT_PATH}'

  tailwind:
    build: .
    volumes:
      - "./:/app"
    depends_on:
      db:
        condition: service_healthy
    command: rails tailwindcss:watch
    stdin_open: true

db:
    image: postgres:17
    ports:
      - "127.0.0.1:5432:5432"
    volumes:
      - db_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER
      - POSTGRES_PASSWORD
      - POSTGRES_DB
    healthcheck:
      test: ["CMD-SHELL", "psql -U $POSTGRES_USER -d $POSTGRES_DB -c 'SELECT 1'"]
      interval: 20s        
      timeout: 10s         
      retries: 5           
      start_period: 10s  

volumes:
  db_data:
```

## 9. Weitere nützliche Befehle:
```bash
# Migrationen ausführen (falls neue Migrationen hinzugefügt wurden):
docker compose run app rails db:migrate

# Neue Migration erstellen:
docker compose run app rails generate migration <migration_name> 

# Datenbank resetten:
docker compose run app rails db:reset

# Logs anzeigen: Um die Logs des laufenden Servers anzuzeigen, kannst du docker compose logs verwenden:
docker compose logs -f
```