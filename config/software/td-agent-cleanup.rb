name "td-agent-cleanup"
#version '' # git ref

dependency "td-agent"

build do
  block do
    project_name = project.name
    gem_dir_version = "3.1.0"

    # remove unnecessary files
    FileUtils.rm_f(Dir.glob("/opt/#{project_name}/embedded/lib/ruby/gems/#{gem_dir_version}/cache/*.gem"))
  end
end
