source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "bcrypt"
gem "bootstrap-sass", "3.3.7"
gem "bootstrap-social-rails"
gem "bootstrap-will_paginate"
gem "cancancan"
gem "carrierwave"
gem "chartkick"
gem "cloudinary"
gem "coffee-rails", "~> 4.2"
gem "config"
gem "devise"
gem "faker"
gem "figaro"
gem "font-awesome-rails"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "mysql2", "~> 0.5.2"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "omniauth-twitter"
gem "puma", "~> 3.7"
gem "rails", "~> 5.1.6"
gem "rails-i18n"
gem "ransack"
gem "responders"
gem "sass-rails", "~> 5.0"
gem "sprockets-rails"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"
gem "will_paginate"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara", "~> 2.13"
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
  gem "selenium-webdriver"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "guard", "2.14.1"
  gem "guard-minitest", "2.4.6"
  gem "minitest", "5.10.3"
  gem "minitest-reporters", "1.1.14"
  gem "rails-controller-testing", "1.0.2"
  gem "shoulda-matchers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
