FROM ruby:3.3.5

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    neovim \
    fish \
    ruby-dev \
    libpq-dev \
    nodejs \
    yarn \
    wget \
    unzip \
    libnss3 \
    libxss1 \
    libgconf-2-4 \
    libappindicator3-1 \
    fonts-liberation \
    libasound2 \
    xdg-utils

RUN chsh -s /usr/bin/fish
ENV EDITOR=nvim

RUN mkdir /app
WORKDIR /app

RUN gem update --system

COPY shell_config/ /root/.config/
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle update --bundler
RUN bundle install
RUN rm -rf /app/tmp/pids/server.pid

CMD fish
