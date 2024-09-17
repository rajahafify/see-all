FROM ruby:3.1.0-alpine

# Set working directory
WORKDIR /app

# Install dependencies
RUN apk add --no-cache build-base postgresql-dev nodejs yarn tzdata git bash ffmpeg less

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the app
COPY . .

# Precompile assets (if necessary)
# RUN bundle exec rails assets:precompile

# Ensure the tmp directory exists
RUN mkdir -p tmp/pids

# Expose port 3000
EXPOSE 3000

CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"]
