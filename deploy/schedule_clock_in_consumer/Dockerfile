FROM ruby:3.2-alpine

# Install dependencies
RUN apk add --no-cache \
  build-base \
  mysql-dev \
  linux-headers \
  libxml2-dev \
  libxslt-dev \
  tzdata \
  git \
  nodejs \
  yarn \
  yaml-dev \
  linux-headers 

# Create app directory
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["bundle", "exec", "rake", "kafka:consume"]
