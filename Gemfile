source 'https://rubygems.org'

# Use Berkshelf for resolving cookbook dependencies
gem 'berkshelf', '~> 3.0'

# Install omnibus software
gem 'omnibus', :github => 'chef/omnibus' #, :branch => '8.0.1'
gem 'omnibus-software', :github => 'chef/omnibus-software' #, :branch => 'omnibus/3.2-stable'

gem 'ohai', '>17.7'
gem 'chef-cleanroom', '1.0.1'

# Use open_uri_redirections to allow HTTPS -> HTTP redirections in omnibus
gem 'open_uri_redirections', '0.2.1'

# Use Test Kitchen with Vagrant for convering the build environment
gem 'test-kitchen',    '~> 2.4'
gem 'kitchen-vagrant', '~> 1.6'

group :test do
  gem 'rake', '~> 10.1.0'
  gem 'serverspec', '~> 2.18.0'
end
