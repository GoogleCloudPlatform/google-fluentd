name "fluentd"

# Note: In order to update the Fluentd version, please update both here and also the fluentd versions in
# https://github.com/GoogleCloudPlatform/fluent-plugin-google-cloud/blob/master/fluent-plugin-google-cloud.gemspec
# and
# https://github.com/GoogleCloudPlatform/google-fluentd/blob/master/windows-installer/generate_sdl_agent_exe.ps1
#
# fluentd v1.16.2.
default_version 'd5685ada81ac89a35a79965f1e94bbe5952a5d3a'

dependency "ruby"
#dependency "bundler"

source :git => 'https://github.com/fluent/fluentd.git'
relative_path "fluentd"

build do
  Dir.glob(File.expand_path(File.join(Omnibus::Config.project_root, 'core_gems', '*.gem'))).sort.each { |gem_path|
    gem "install --no-document #{gem_path}"
  }
  rake "build"
  gem "install --no-document pkg/fluentd-*.gem"
end
