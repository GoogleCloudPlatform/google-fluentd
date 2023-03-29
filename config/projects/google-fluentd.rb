require 'erb'
require 'fileutils'
require 'rubygems'

name "google-fluentd"
maintainer "Google, Inc."
homepage "http://cloud.google.com/logging/docs/"
description "Google Fluentd: A data collector for Google Cloud Logging"

install_dir     "/opt/google-fluentd"
build_version   "1.9.13"
build_iteration 1

# creates required build directories
dependency "preparation"

override :ruby, :version => '2.7.6'
override :zlib, :version => '1.2.8'
override :rubygems, :version => '3.0.0'
override :postgresql, :version => '9.6.24'

# td-agent dependencies/components
dependency "td-agent"
dependency "td-agent-files"
dependency "td"
dependency "td-agent-ui"
dependency "td-agent-cleanup"

# version manifest file
dependency "version-manifest"

case ohai["os"]
when "linux"
  case ohai["platform_family"]
  when "amazon"
    if /^201/ =~ ohai["platform_version"]
      package :rpm do
        dist_tag ".amzn1"
      end
    end
    runtime_dependency "initscripts"
    runtime_dependency "redhat-lsb-core"
  when "debian"
    runtime_dependency "lsb-base"
  when "rhel"
    runtime_dependency "initscripts"
    if ohai["platform_version"][0] == "5"
      runtime_dependency "redhat-lsb"
    else
      runtime_dependency "redhat-lsb-core"
    end
  when "suse"
    runtime_dependency "lsb-release"
    runtime_dependency "insserv-compat"
    # sysvinit-tools is required for insserv-compat, but isn't a dependency
    runtime_dependency "sysvinit-tools"
  end
end

exclude "\.git*"
exclude "bundler\/git"

compress :dmg do
end
