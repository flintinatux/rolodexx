source 'https://rubygems.org'
ruby   '2.1.1'

# Rails
gem 'rails', '4.0.3'

# Backend
gem 'foreman'
gem 'pg'
gem 'puma'

# Frontend - all done with Brunch.io

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'faker'
  gem 'rspec-rails'
  gem 'sqlite3'
end

group :development do
  gem 'annotate'
end

group :test do
  gem 'database_cleaner', '~> 1'
  gem 'factory_girl_rails'
end
