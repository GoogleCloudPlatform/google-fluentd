source 'https://rubygems.org'

# Use Berkshelf for resolving cookbook dependencies
gem 'berkshelf', '~> 3.0'

# Install omnibus software
gem 'omnibus', :github => 'chef/omnibus'
gem 'omnibus-software', :github => 'chef/omnibus-software'

gem 'kubeclient', '4.10.1'

gem 'ohai', '>17.7'
gem 'chef-cleanroom', '1.0.5'

# Use open_uri_redirections to allow HTTPS -> HTTP redirections in omnibus
gem 'open_uri_redirections', '0.2.1'

# Use Test Kitchen with Vagrant for convering the build environment
gem 'test-kitchen',    '~> 2.4'
gem 'kitchen-vagrant', '~> 1.6'

group :test do
  gem 'rake', '~> 13.0.6'
  gem 'serverspec', '~> 2.18.0'
end
