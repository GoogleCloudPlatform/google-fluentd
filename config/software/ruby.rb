#
# Copyright 2012-2016 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "ruby"

license "BSD-2-Clause"
license_file "BSDL"
license_file "COPYING"
license_file "LEGAL"

# - chef-client cannot use 2.2.x yet due to a bug in IRB that affects chef-shell on linux:
#   https://bugs.ruby-lang.org/issues/11869
# - the current status of 2.3.x is that it downloads but fails to compile.
# - verify that all ffi libs are available for your version on all platforms.
# - Note: When updating major version (i.e. 2.2 -> 2.3), gem_dir_version must be
#   updated to 2.X.0 in td.rb, td-agent-cleanup.rb, td-agent-files.rb, and
#   td-agent-ui.rb.
default_version "2.6.9"

fips_enabled = (project.overrides[:fips] && project.overrides[:fips][:enabled]) || false

dependency "patch" if solaris_10?
dependency "ncurses" unless windows? || version.satisfies?(">= 2.1")
dependency "zlib"
dependency "openssl"
dependency "libedit" unless windows?
dependency "libffi"
dependency "libyaml"
# Needed for chef_gem installs of (e.g.) nokogiri on upgrades -
# they expect to see our libiconv instead of a system version.
# Ignore on windows - TDM GCC comes with libiconv in the runtime
# and that's the only one we will ever use.
dependency "libiconv"

# The checksums below are for the *.tar.gz packages.
version("2.6.9")      { source sha256: "eb7bae7aac64bf9eb2153710a4cafae450ccbb62ae6f63d573e1786178b0efbb" }
version("2.6.8")      { source sha256: "1807b78577bc08596a390e8a41aede37b8512190e05c133b17d0501791a8ca6d" }
version("2.6.7")      { source sha256: "e4227e8b7f65485ecb73397a83e0d09dcd39f25efd411c782b69424e55c7a99e" }
version("2.6.6")      { source sha256: "364b143def360bac1b74eb56ed60b1a0dca6439b00157ae11ff77d5cd2e92291" }
version("2.6.5")      { source sha256: "66976b716ecc1fd34f9b7c3c2b07bbd37631815377a2e3e85a5b194cfdcbed7d" }
version("2.6.4")      { source sha256: "4fc1d8ba75505b3797020a6ffc85a8bcff6adc4dabae343b6572bf281ee17937" }
version("2.6.3")      { source sha256: "577fd3795f22b8d91c1d4e6733637b0394d4082db659fccf224c774a2b1c82fb" }
version("2.6.2")      { source sha256: "a0405d2bf2c2d2f332033b70dff354d224a864ab0edd462b7a413420453b49ab" }
version("2.6.1")      { source sha256: "17024fb7bb203d9cf7a5a42c78ff6ce77140f9d083676044a7db67f1e5191cb8" }

version("2.5.7")      { source sha256: "0b2d0d5e3451b6ab454f81b1bfca007407c0548dea403f1eba2e429da4add6d4" }
version("2.5.6")      { source sha256: "1d7ed06c673020cd12a737ed686470552e8e99d72b82cd3c26daa3115c36bea7" }
version("2.5.5")      { source sha256: "28a945fdf340e6ba04fc890b98648342e3cccfd6d223a48f3810572f11b2514c" }
version("2.5.4")      { source sha256: "0e4042bce749352dfcf1b9e3013ba7c078b728f51f8adaf6470ce37675e3cb1f" }
version("2.5.3")      { source sha256: "9828d03852c37c20fa333a0264f2490f07338576734d910ee3fd538c9520846c" }
version("2.5.1")      { source sha256: "dac81822325b79c3ba9532b048c2123357d3310b2b40024202f360251d9829b1" }
version("2.5.0")      { source sha256: "46e6f3630f1888eb653b15fa811d77b5b1df6fd7a3af436b343cfe4f4503f2ab" }

version("2.4.5")      { source sha256: "6737741ae6ffa61174c8a3dcdd8ba92bc38827827ab1d7ea1ec78bc3cefc5198" }
version("2.4.4")      { source sha256: "254f1c1a79e4cc814d1e7320bc5bdd995dc57e08727d30a767664619a9c8ae5a" }
version("2.4.3")      { source sha256: "fd0375582c92045aa7d31854e724471fb469e11a4b08ff334d39052ccaaa3a98" }
version("2.4.2")      { source sha256: "93b9e75e00b262bc4def6b26b7ae8717efc252c47154abb7392e54357e6c8c9c" }
version("2.4.1")      { source sha256: "a330e10d5cb5e53b3a0078326c5731888bb55e32c4abfeb27d9e7f8e5d000250" }
version("2.4.0")      { source sha256: "152fd0bd15a90b4a18213448f485d4b53e9f7662e1508190aa5b702446b29e3d" }

version("2.3.7")      { source sha256: "35cd349cddf78e4a0640d28ec8c7e88a2ae0db51ebd8926cd232bb70db2c7d7f" }
version("2.3.6")      { source sha256: "8322513279f9edfa612d445bc111a87894fac1128eaa539301cebfc0dd51571e" }
version("2.3.3")      { source sha256: "241408c8c555b258846368830a06146e4849a1d58dcaf6b14a3b6a73058115b7" }
version("2.3.1")      { source sha256: "b87c738cb2032bf4920fef8e3864dc5cf8eae9d89d8d523ce0236945c5797dcd" }
version("2.3.0")      { source md5: "e81740ac7b14a9f837e9573601db3162" }

version("2.2.7")      { source sha256: "374184c6c5bbc88fb7bad422368d4053a236fb6587f0eff76146dcba57f93da5" }
version("2.2.6")      { source sha256: "de8e192791cb157d610c48a9a9ff6e7f19d67ce86052feae62b82e3682cc675f" }
version("2.2.5")      { source md5: "bd8e349d4fb2c75d90817649674f94be" }
version("2.2.4")      { source md5: "9a5e15f9d5255ba37ace18771b0a8dd2" }
version("2.2.3")      { source md5: "150a5efc5f5d8a8011f30aa2594a7654" }
version("2.2.2")      { source md5: "326e99ddc75381c7b50c85f7089f3260" }
version("2.2.1")      { source md5: "b49fc67a834e4f77249eb73eecffb1c9" }
version("2.2.0")      { source md5: "cd03b28fd0b555970f5c4fd481700852" }

version("2.1.10")     { source sha256: "fb2e454d7a5e5a39eb54db0ec666f53eeb6edc593d1d2b970ae4d150b831dd20" }
version("2.1.9")      { source sha256: "034cb9c50676d2c09b3b6cf5c8003585acea05008d9a29fa737c54d52c1eb70c" }
version("2.1.8")      { source md5: "091b62f0a9796a3c55de2a228a0e6ef3" }
version("2.1.7")      { source md5: "2e143b8e19b056df46479ae4412550c9" }
version("2.1.6")      { source md5: "6e5564364be085c45576787b48eeb75f" }
version("2.1.5")      { source md5: "df4c1b23f624a50513c7a78cb51a13dc" }
version("2.1.4")      { source md5: "89b2f4a197621346f6724a3c35535b19" }
version("2.1.3")      { source md5: "74a37b9ad90e4ea63c0eed32b9d5b18f" }
version("2.1.2")      { source md5: "a5b5c83565f8bd954ee522bd287d2ca1" }
version("2.1.1")      { source md5: "e57fdbb8ed56e70c43f39c79da1654b2" }

version("2.0.0-p645") { source md5: "49919bba0c855eaf8e247108c7933a62" }
version("2.0.0-p594") { source md5: "a9caa406da5d72f190e28344e747ee74" }
version("2.0.0-p576") { source md5: "2e1f4355981b754d92f7e2cc456f843d" }

version("1.9.3-p550") { source md5: "e05135be8f109b2845229c4f47f980fd" }
version("1.9.3-p547") { source md5: "7531f9b1b35b16f3eb3d7bea786babfd" }
version("1.9.3-p484") { source md5: "8ac0dee72fe12d75c8b2d0ef5d0c2968" }

source url: "https://cache.ruby-lang.org/pub/ruby/#{version.match(/^(\d+\.\d+)/)[0]}/ruby-#{version}.tar.gz"

relative_path "ruby-#{version}"

env = with_standard_compiler_flags(with_embedded_path)

if mac_os_x?
  # -Qunused-arguments suppresses "argument unused during compilation"
  # warnings. These can be produced if you compile a program that doesn't
  # link to anything in a path given with -Lextra-libs. Normally these
  # would be harmless, except that autoconf treats any output to stderr as
  # a failure when it makes a test program to check your CFLAGS (regardless
  # of the actual exit code from the compiler).
  env["CFLAGS"] << " -I#{install_dir}/embedded/include/ncurses -arch x86_64 -m64 -O3 -g -pipe -Qunused-arguments"
  env["LDFLAGS"] << " -arch x86_64"
elsif freebsd?
  # Stops "libtinfo.so.5.9: could not read symbols: Bad value" error when
  # compiling ext/readline. See the following for more info:
  #
  #   https://lists.freebsd.org/pipermail/freebsd-current/2013-October/045425.html
  #   http://mailing.freebsd.ports-bugs.narkive.com/kCgK8sNQ/ports-183106-patch-sysutils-libcdio-does-not-build-on-10-0-and-head
  #
  env["LDFLAGS"] << " -ltinfow"
elsif aix?
  # this magic per IBM
  env["LDSHARED"] = "xlc -G"
  env["CFLAGS"] = "-I#{install_dir}/embedded/include/ncurses -I#{install_dir}/embedded/include"
  # this magic per IBM
  env["XCFLAGS"] = "-DRUBY_EXPORT"
  # need CPPFLAGS set so ruby doesn't try to be too clever
  env["CPPFLAGS"] = "-I#{install_dir}/embedded/include/ncurses -I#{install_dir}/embedded/include"
  env["SOLIBS"] = "-lm -lc"
  # need to use GNU m4, default m4 doesn't work
  env["M4"] = "/opt/freeware/bin/m4"
elsif solaris_10?
  if sparc?
    # Known issue with rubby where too much GCC optimization blows up miniruby on sparc
    env["CFLAGS"] << " -std=c99 -O0 -g -pipe -mcpu=v9"
    env["LDFLAGS"] << " -mcpu=v9"
  else
    env["CFLAGS"] << " -std=c99 -O3 -g -pipe"
  end
elsif windows?
  env["CPPFLAGS"] << " -DFD_SETSIZE=2048"
else # including linux
  if version.satisfies?(">= 2.3.0") &&
      rhel? && platform_version.satisfies?("< 6.0")
    env["CFLAGS"] << " -O2 -g -pipe"
  else
    env["CFLAGS"] << " -O3 -g -pipe"
  end
end

build do
  # AIX needs /opt/freeware/bin only for patch
  patch_env = env.dup
  patch_env["PATH"] = "/opt/freeware/bin:#{env['PATH']}" if aix?

  if solaris_10? && version.satisfies?(">= 2.1")
    patch source: "ruby-no-stack-protector.patch", plevel: 1, env: patch_env
  elsif solaris_10? && version =~ /^1.9/
    patch source: "ruby-sparc-1.9.3-c99.patch", plevel: 1, env: patch_env
  elsif solaris_11? && version =~ /^2.1/
    patch source: "ruby-solaris-linux-socket-compat.patch", plevel: 1, env: patch_env
  end

  # wrlinux7/ios_xr build boxes from Cisco include libssp and there is no way to
  # disable ruby from linking against it, but Cisco switches will not have the
  # library.  Disabling it as we do for Solaris.
  if ios_xr? && version.satisfies?(">= 2.1")
    patch source: "ruby-no-stack-protector.patch", plevel: 1, env: patch_env
  end

  # disable libpath in mkmf across all platforms, it trolls omnibus and
  # breaks the postgresql cookbook.  i'm not sure why ruby authors decided
  # this was a good idea, but it breaks our use case hard.  AIX cannot even
  # compile without removing it, and it breaks some native gem installs on
  # other platforms.  generally you need to have a condition where the
  # embedded and non-embedded libs get into a fight (libiconv, openssl, etc)
  # and ruby trying to set LD_LIBRARY_PATH itself gets it wrong.
  #
  # Also, fix paths emitted in the makefile on windows on both msys and msys2.
  if version.satisfies?(">= 2.1")
    patch source: "ruby-mkmf.patch", plevel: 1, env: patch_env
    # should intentionally break and fail to apply on 2.2, patch will need to
    # be fixed.
  end

  # Fix reserve stack segmentation fault when building on RHEL5 or below
  # Currently only affects 2.1.7 and 2.2.3. This patch taken from the fix
  # in Ruby trunk and expected to be included in future point releases.
  # https://redmine.ruby-lang.org/issues/11602
  if rhel? &&
      platform_version.satisfies?("< 6") &&
      (version == "2.1.7" || version == "2.2.3")

    patch source: "ruby-fix-reserve-stack-segfault.patch", plevel: 1, env: patch_env
  end

  if version.start_with?('2.1')
    patch source: 'ruby-2.1-openssl-mode-patch.patch', plevel: 1, env: patch_env
  end

  configure_command = ["--with-out-ext=dbm,gdbm,probe,racc,sdbm,tk",
                       "--enable-shared",
                       "--enable-libedit",
                       "--disable-install-doc",
                       "--without-gmp",
                       "--without-gdbm",
                       "--without-tk",
                       "--disable-dtrace"]
  configure_command << "--with-ext=psych" if version.satisfies?("< 2.3")
  configure_command << "--with-bundled-md5" if fips_enabled

  # resolve C99 code accidentally introduced in Ruby 2.6.7 and it's still in 2.6.8 :(
  patch source: "ruby-2.6.7_c99.patch", plevel: 1, env: patch_env if version.satisfies?("~> 2.6.7")

  if aix?
    # need to patch ruby's configure file so it knows how to find shared libraries
    patch source: "ruby-aix-configure.patch", plevel: 1, env: patch_env
    # have ruby use zlib on AIX correctly
    patch source: "ruby_aix_openssl.patch", plevel: 1, env: patch_env
    # AIX has issues with ssl retries, need to patch to have it retry
    patch source: "ruby_aix_2_1_3_ssl_EAGAIN.patch", plevel: 1, env: patch_env
    # the next two patches are because xlc doesn't deal with long vs int types well
    patch source: "ruby-aix-atomic.patch", plevel: 1, env: patch_env
    patch source: "ruby-aix-vm-core.patch", plevel: 1, env: patch_env

    # per IBM, just help ruby along on what it's running on
    configure_command << "--host=powerpc-ibm-aix6.1.0.0 --target=powerpc-ibm-aix6.1.0.0 --build=powerpc-ibm-aix6.1.0.0 --enable-pthread"

  elsif freebsd?
    # Disable optional support C level backtrace support. This requires the
    # optional devel/libexecinfo port to be installed.
    configure_command << "ac_cv_header_execinfo_h=no"
    configure_command << "--with-opt-dir=#{install_dir}/embedded"
  elsif smartos?
    # Opscode patch - someara@opscode.com
    # GCC 4.7.0 chokes on mismatched function types between OpenSSL 1.0.1c and Ruby 1.9.3-p286
    patch source: "ruby-openssl-1.0.1c.patch", plevel: 1, env: patch_env

    # Patches taken from RVM.
    # http://bugs.ruby-lang.org/issues/5384
    # https://www.illumos.org/issues/1587
    # https://github.com/wayneeseguin/rvm/issues/719
    patch source: "rvm-cflags.patch", plevel: 1, env: patch_env

    # From RVM forum
    # https://github.com/wayneeseguin/rvm/commit/86766534fcc26f4582f23842a4d3789707ce6b96
    configure_command << "ac_cv_func_dl_iterate_phdr=no"
    configure_command << "--with-opt-dir=#{install_dir}/embedded"
  elsif windows?
    configure_command << " debugflags=-g"
  else
    configure_command << "--with-opt-dir=#{install_dir}/embedded"
  end

  # FFS: works around a bug that infects AIX when it picks up our pkg-config
  # AFAIK, ruby does not need or use this pkg-config it just causes the build to fail.
  # The alternative would be to patch configure to remove all the pkg-config garbage entirely
  env["PKG_CONFIG"] = "/bin/true" if aix?

  configure(*configure_command, env: env)
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env

  if windows?
    # Needed now that we switched to msys2 and have not figured out how to tell
    # it how to statically link yet
    dlls = ["libwinpthread-1"]
    if windows_arch_i386?
      dlls << "libgcc_s_dw2-1"
    else
      dlls << "libgcc_s_seh-1"
    end
    dlls.each do |dll|
      arch_suffix = windows_arch_i386? ? "32" : "64"
      windows_path = "C:/msys2/mingw#{arch_suffix}/bin/#{dll}.dll"
      if File.exist?(windows_path)
        copy windows_path, "#{install_dir}/embedded/bin/#{dll}.dll"
      else
        raise "Cannot find required DLL needed for dynamic linking: #{windows_path}"
      end
    end
  else
  end

end
