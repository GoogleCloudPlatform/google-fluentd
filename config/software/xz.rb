name "xz"
default_version "5.2.3"

version "5.2.3" do
  source md5: "ef68674fb47a8b8e741b34e429d86e9d"
end

version "5.2.2" do
  source md5: "7cf6a8544a7dae8e8106fdf7addfa28c"
end

version "5.2.1" do
  source md5: "3e44c766c3fb4f19e348e646fcd5778a"
end

source url: "https://storage.googleapis.com/stackdriver-fluentd-vendor-storage/xz-#{version}.tar.gz"

relative_path "xz-#{version}"

env = with_standard_compiler_flags(with_embedded_path)

build do
  command ["./configure", '--disable-debug',
           "--prefix=#{install_dir}/embedded"].join(" "), :env => env
  make "-j #{workers}", :env => env
  make "install", :env => env
end
