FROM ruby:2.6

ENV RAILS_ENV=development

# Install requirements for ruby gems.
RUN apt-get update && apt-get install -y aptitude
RUN aptitude install -y libssl-dev g++ libxml2 libxslt-dev libreadline-dev libicu-dev imagemagick libmagick-dev
RUN aptitude install -y nano

RUN gem update --system 3.2.3
RUN gem install bundler

WORKDIR /app

COPY lib/matestack/renderer/version.rb ./lib/matestack/renderer/
COPY Gemfile Gemfile.lock matestack-renderer.gemspec .
RUN bundle install --retry=5 --jobs=5
