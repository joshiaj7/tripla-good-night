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

# Set up gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the app
COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
