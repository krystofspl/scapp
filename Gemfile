source 'https://rubygems.org'
ruby '2.1.6'
gem 'rails', '4.1.7'
# CSS preprocessor
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
# JS preprocessor
gem 'coffee-rails', '~> 4.0.0'
# JS jQuery library
gem 'jquery-rails', '~> 3.1.2'
gem 'jquery-scrollto-rails'
# page speedup loader - replacing only document body and changed assets
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 1.2'
# twitter bootstrap tem,plate framework
gem 'bootstrap-sass', '~> 3.3.4'
# add user permissions support for controller actions
gem 'cancan'
# user authentication
gem 'devise'
# configuration in YAML
gem 'figaro'
# templating engine
gem 'haml-rails'
gem 'mysql2'
# user authorization - user role support
gem 'rolify'
# html form builder
gem 'simple_form'
gem 'therubyracer', :platform=>:ruby
# seo identifiers in url (5.0.4 breaks composite_primary_keys)
gem 'friendly_id', '= 5.0.3'
# ruby statistic package
gem 'statsample', '~> 1.3.0'
# breadcrumb & navigation builder
gem 'gretel'
# model pagination
gem 'kaminari'
gem 'bootstrap-kaminari-views'
# datetime picker for bootstrap
gem 'momentjs-rails', '>=2.8.1', :github => 'derekprior/momentjs-rails'
# this has to be run after bundle install: "rails generate datetimepicker_rails:install Font-Awesome"
gem 'datetimepicker-rails', :require => 'datetimepicker-rails', :git => 'git://github.com/zpaulovics/datetimepicker-rails.git', branch: 'master', submodules: true
# image upload + manipulation
gem 'carrierwave'
gem 'rmagick'
# handling foreign keys
gem 'foreigner', '~>1.4.2'
gem 'immigrant'
# configuration
gem 'settingslogic'
# composite primary keys
gem 'composite_primary_keys', '~>7.0.0'
# ranked model for dynamic table rows ordering (used in excsteps)
gem 'ranked-model'
# filtering results
gem 'filterrific'
gem 'owlcarousel-rails', github: 'acrogenesis/owlcarousel-rails', branch: 'OwlCarousel2'
# makes routes accessible in JS (url_for not sufficient sometimes)
gem 'js-routes'

gem 'rails_12factor', group: :production
group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'relish', '~>0.7'
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end
group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require=>false
  gem 'selenium-webdriver', '>=2.45.0.dev3' #temporary version because of a bug
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'launchy'
end
