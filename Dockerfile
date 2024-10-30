# Use an official Ruby runtime as a parent image
FROM ruby:2.7

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set up the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Install gems
RUN bundle install

# Copy the rest of the application files into the container
COPY . /app

# Precompile assets (if your app has assets)
RUN bundle exec rake assets:precompile || true

# Expose the port that the app runs on
EXPOSE 3000

# Start the server by default
CMD ["rails", "server", "-b", "0.0.0.0"]
