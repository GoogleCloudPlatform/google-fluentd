name "td-agent-files"
#version '' # git ref

dependency "td-agent"

# This software setup td-agent related files, e.g. etc files.
# Separating file into td-agent.rb and td-agent-files.rb is for speed up package building

build do
  block do
    # setup related files
    pkg_type = project.packagers_for_system.first.id.to_s
    root_path = "/" # for ERB
    install_path = project.install_dir # for ERB
    project_name = project.name # for ERB
    project_name_snake = project.name.gsub('-', '_') # for variable names in ERB
    gem_dir_version = "3.1.0"
    use_systemd = ohai["os"] == "linux" && ohai["platform_family"] == "suse"

    template = ->(*parts) { File.join('templates', *parts) }
    generate_from_template = ->(dst, src, erb_binding, opts={}) {
      mode = opts.fetch(:mode, 0755)
      destination = dst.gsub('td-agent', project.name)
      FileUtils.mkdir_p File.dirname(destination)
      File.open(destination, 'w', mode) do |f|
        f.write ERB.new(File.read(src)).result(erb_binding)
      end
    }

    # copy pre/post scripts into omnibus path (./package-scripts/td-agentN)
    FileUtils.mkdir_p(project.package_scripts_path)
    Dir.glob(File.join(project.package_scripts_path, '*')).each { |f|
      FileUtils.rm_f(f) if File.file?(f)
    }
    # templates/package-scripts/td-agent/xxxx/* -> ./package-scripts/td-agentN
    Dir.glob(template.call('package-scripts', 'td-agent', pkg_type, '*')).each { |f|
      package_script = File.join(project.package_scripts_path, File.basename(f))
      generate_from_template.call package_script, f, binding, mode: 0755
    }

    # setup plist / init.d file
    if ['pkg', 'dmg'].include?(pkg_type)
      # templates/td-agent.plist.erb -> INSTALL_PATH/td-agent.plist
      plist_path = File.join(install_path, "td-agent.plist")
      generate_from_template.call plist_path, template.call("td-agent.plist.erb"), binding, mode: 0755
    else
      # templates/etc/init.d/xxxx/td-agent -> ./resources/etc/init.d/td-agent
      initd_file_path = File.join(project.resources_path, 'etc', 'init.d', project.name)
      generate_from_template.call initd_file_path, template.call('etc', 'init.d', pkg_type, 'td-agent'), binding, mode: 0755
    end

    # setup /etc/td-agent
    ['td-agent.conf', 'td-agent.conf.tmpl', ['logrotate.d', 'td-agent.logrotate'], ['prelink.conf.d', 'td-agent.conf']].each { |item|
      conf_path = File.join(project.resources_path, 'etc', 'td-agent', *([item].flatten))
      generate_from_template.call conf_path, template.call('etc', 'td-agent', *([item].flatten)), binding, mode: 0644
    }

    ["td-agent", "td-agent-gem"].each { |command|
      sbin_path = File.join(install_path, 'usr', 'sbin', command)
      # templates/usr/sbin/yyyy.erb -> INSTALL_PATH/usr/sbin/yyyy
      generate_from_template.call sbin_path, template.call('usr', 'sbin', "#{command}.erb"), binding, mode: 0755
    }

    FileUtils.remove_entry_secure(File.join(install_path, 'etc'), true)
    # ./resources/etc -> INSTALL_PATH/etc
    FileUtils.cp_r(File.join(project.resources_path, 'etc'), install_path)
  end
end
