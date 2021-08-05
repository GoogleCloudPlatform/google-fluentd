name "td-agent"
#version '' # git ref

# TODO: Remove this override once there's a fix released for
#       https://github.com/sparklemotion/nokogiri/issues/2302
override :nokogiri, version: "1.11.7"

dependency "jemalloc"
dependency "ruby"
dependency "nokogiri"
dependency "postgresql"
dependency "fluentd"
dependency "xz"

env = {}

build do
  Dir.glob(File.expand_path(File.join(Omnibus::Config.project_root, 'plugin_gems', '*.gem'))).sort.each { |gem_path|
    args = ''
    if project.ohai['platform_family'] == 'mac_os_x' && gem_path.include?('-thrift-')
      # See: https://issues.apache.org/jira/browse/THRIFT-2219
      args << " -- --with-cppflags='-D_FORTIFY_SOURCE=0'"
    end
    gem "install --no-document #{gem_path} #{args}", :env => env
  }
end
