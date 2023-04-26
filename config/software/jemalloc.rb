name "jemalloc"
default_version "5.3.0"

# for td-agent
version("5.3.0") do
  sha512 = '22907bb052096e2caffb6e4e23548aecc5cc9283dce476896a2b1127eee64170e3562fa2e7db9571298814a7a2c7df6e8d1fbe152bd3f3b0c1abec22a2de34b1'
  source :sha512 => sha512,
         :url => "http://src.fedoraproject.org/repo/pkgs/jemalloc/jemalloc-#{version}.tar.bz2/sha512/#{sha512}/jemalloc-#{version}.tar.bz2"
end
version("4.5.0") do
  sha512 = '76953363fe1007952232220afa1a91da4c1c33c02369b5ad239d8dd1d0792141197c15e8489a8f4cd301b08494e65cadd8ecd34d025cb0285700dd78d7248821'
  source :sha512 => sha512,
         :url => "http://src.fedoraproject.org/repo/pkgs/jemalloc/jemalloc-#{version}.tar.bz2/sha512/#{sha512}/jemalloc-#{version}.tar.bz2"
end
version("4.2.1") do
  md5 = '094b0a7b8c77c464d0dc8f0643fd3901'
  source :md5 => md5,
         :url => "http://src.fedoraproject.org/repo/pkgs/jemalloc/jemalloc-#{version}.tar.bz2/#{md5}/jemalloc-#{version}.tar.bz2"
end
version("3.6.0") do
  md5 = 'e76665b63a8fddf4c9f26d2fa67afdf2'
  source :md5 => md5,
         :url => "http://src.fedoraproject.org/repo/pkgs/jemalloc/jemalloc-#{version}.tar.bz2/#{md5}/jemalloc-#{version}.tar.bz2"
end
version("2.2.5") do
  md5 = 'a5c4332705ed0e3fff1ac73cfe975640'
  source :md5 => md5,
         :url => "http://src.fedoraproject.org/repo/pkgs/jemalloc/jemalloc-#{version}.tar.bz2/#{md5}/jemalloc-#{version}.tar.bz2"
end

# On Mac, this file blocks package building at health check so add to whitelist
whitelist_file "libjemalloc\.1\.dylib"

relative_path "jemalloc-#{version}"

env = with_standard_compiler_flags(with_embedded_path)

build do
  command ["./configure", '--disable-debug',
           "--prefix=#{install_dir}/embedded"].join(" "), :env => env
  make "-j #{workers}", :env => env
  make "install", :env => env
end
