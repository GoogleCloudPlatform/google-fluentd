<#
 Script to pull down all needed dependencies and generate an unsigned
 Stackdriver Logging Agent installer.

 This should be run on a clean GCE windows instance.

 The installer assumes that all NSIS files (.nsi, .nsh, and needed image files)
 are in the same folder as the installer script.  The script will output the
 complete Stackdriver Logging Agent Installer named GoogleStackdriverLoggingAgent_unsigned.exe.
#>

##############################
#  ARGUMENTS
##############################

Param(
  [string]$version = (Get-Content "$PSScriptRoot\..\windows-installer\VERSION"),
  [string]$localOutputGemDir
)

##############################
#  TRACING AND ERROR HANDLING
##############################

Set-PSDebug -Trace 1
$ErrorActionPreference = 'Stop'

##############################
#  VARIABLES - DIRECTORIES
##############################

# Just install into current directory for simplicity.
$BASE_INSTALLER_DIR = [string](Get-Location)
# Re-enable tracing.
Set-PSDebug -Trace 1

# The path of where ruby and all gems will be.  This is the portion that will be
# packaged and zipped up.
$SD_LOGGING_AGENT_DIR = $BASE_INSTALLER_DIR + "\GoogleStackdriverLoggingAgent"

# The ruby dev kit location.  This is not needed in the final package.
$RUBY_DEV_DIR = $SD_LOGGING_AGENT_DIR + "\msys32"

# The NSIS location.  Used to compile the Stackdriver Logging Agent installer.
$NSIS_DIR = $BASE_INSTALLER_DIR + "\NSIS"

# The location of the NSIS plugin to unzip files.
$NSIS_UNZU_DIR = $BASE_INSTALLER_DIR + "\NSISunzU"

# The location for unicode plugins for NSIS.
$NSIS_UNICODE_PLUGIN_DIR = $NSIS_DIR + "\Plugins\x86-unicode"


##############################
#  VARIABLES - INSTALLERS
##############################

# Locations of the needed installers and dependencies.
$RUBY_INSTALLER = $SD_LOGGING_AGENT_DIR + "\rubyinstaller.exe"
$NSIS_INSTALLER = $BASE_INSTALLER_DIR + "\nsisinstaller.exe"
$NSIS_UNZU_ZIP = $BASE_INSTALLER_DIR + "\NSISunzU.zip"


# Links for each installer.
$RUBY_INSTALLER_LINK = "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.5-1/rubyinstaller-devkit-2.6.5-1-x86.exe"
$NSIS_INSTALLER_LINK = "http://downloads.sourceforge.net/project/nsis/NSIS%203/3.0/nsis-3.0-setup.exe"
$NSIS_UNZU_INSTALLER_LINK = "http://nsis.sourceforge.net/mediawiki/images/5/5a/NSISunzU.zip"


##############################
#  VARIABLES - FILE LOCATIONS
##############################

$SRC_ROOT = $PSScriptRoot + "\.."

# The location of the ruby executable, used to set up the ruby dev kit.
$RUBY_EXE = $SD_LOGGING_AGENT_DIR + "\bin\ruby.exe"

# The location of the gem batch file, used to download gems.
$GEM_CMD = $SD_LOGGING_AGENT_DIR + "\bin\gem.cmd"

# The location of the executable to compile an NSIS installer.
$NSIS_MAKE = $NSIS_DIR + "\makensis.exe"

# The location of the dll of the plugin to unzip files in an NSIS installer.
$NSIS_UNZU_DLL = $NSIS_UNZU_DIR + "\NSISunzU\Plugin unicode\nsisunz.dll"

# Output location of the zip compliled into the installer. It will place where ever
# this script it run from.
$STACKDRIVER_ZIP = $PSScriptRoot + "\GoogleStackdriverLoggingAgent.zip"

# The location of the Stackdriver Logging Agent installer script. It will look
# where ever this script is run from.
$STACKDRIVER_NSI = $PSScriptRoot + "\setup.nsi"


##############################
#  STEP 1 - CREATE THE NEEDED DIRECTORIES.
##############################

rm -r -Force $SD_LOGGING_AGENT_DIR -ErrorAction Ignore
mkdir $SD_LOGGING_AGENT_DIR
rm -r -Force $NSIS_UNZU_DIR -ErrorAction Ignore
mkdir $NSIS_UNZU_DIR


##############################
#  STEP 2 - DOWNLOAD THE NEEDED DEPENDENCIES.
##############################

# No progress bars.
$ProgressPreference = "silentlyContinue"
# Handle SSL correctly.
[Net.ServicePointManager]::SecurityProtocol = 'TLS12'
# Pretend to be curl for Sourceforge redirects to work.
Invoke-WebRequest "$RUBY_INSTALLER_LINK" -OutFile "$RUBY_INSTALLER" -UserAgent "curl/7.60.0"
Invoke-WebRequest "$NSIS_INSTALLER_LINK" -OutFile "$NSIS_INSTALLER" -UserAgent "curl/7.60.0"
Invoke-WebRequest "$NSIS_UNZU_INSTALLER_LINK" -OutFile "$NSIS_UNZU_ZIP" -UserAgent "curl/7.60.0"
# Re-enable tracing.
Set-PSDebug -Trace 1


##############################
#  STEP 3 - INSTALL RUBY AND THE RUBY DEV KIT.
##############################

# Install ruby to the main install location and wait for it to finish.
& $RUBY_INSTALLER /verysilent /tasks="assocfiles,modpath" /dir=$SD_LOGGING_AGENT_DIR | Out-Null

# Remove the ruby uninstallers and the installer.
rm $SD_LOGGING_AGENT_DIR\unins*
rm $RUBY_INSTALLER


# Update the environment paths.
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")


##############################
#  STEP 4 - INSTALL THE GEMS
##############################
#
# Install the needed gems for google fluentd to work.
#
# These are all a known set of versions which work together. Be sure things work if you
# update any of them.
#
# We install all gems with '--no-document' so we don't pull in
# unneeded docs that bloat the file size (and also seem to cause issues with unzipping).
###############################

$gem_installer = $SRC_ROOT + '\bin\gem_installer'
$core_gems_rb = $SRC_ROOT + '\core_gems.rb'
$plugin_gems_rb = $SRC_ROOT + '\plugin_gems.rb'
# Pin ffi version until https://github.com/ffi/ffi/issues/868 is resolved.
& $GEM_CMD install ffi:1.14.1 --no-document

# Note: In order to update the Fluentd version, please update both here and also
# the fluentd versions in
# https://github.com/GoogleCloudPlatform/fluent-plugin-google-cloud/blob/master/fluent-plugin-google-cloud.gemspec
# and
# https://github.com/GoogleCloudPlatform/google-fluentd/blob/master/config/software/fluentd.rb
& $GEM_CMD install fluentd:1.13.3 --no-document
& $RUBY_EXE $gem_installer $core_gems_rb
& $RUBY_EXE $gem_installer $plugin_gems_rb


if ($localOutputGemDir -ne $null) {
  Push-Location $localOutputGemDir
  Get-ChildItem
  & $GEM_CMD build fluent-plugin-google-cloud.gemspec
  & $GEM_CMD install fluent-plugin-google-cloud*.gem --no-document
  Pop-Location
}

##############################
#  STEP 4.1 - TEMPORARY HACK TO UPDATE RUBY FILE
##############################
#
# TODO: Update $needle and eventlog_rb_replacement.txt when https://github.com/djberg96/win32-eventlog/pull/24 is released.
# TODO: Remove this step when both https://github.com/djberg96/win32-eventlog/pull/24 and https://github.com/djberg96/win32-eventlog/pull/23 are merged and released.
##############################

$eventlog_gem_dir = (& $GEM_CMD which win32-eventlog | Split-Path -parent)
$eventlog_rb = $eventlog_gem_dir + '\win32\eventlog.rb'
$needle = 'max_insert = [num, buf.read_string.scan(/%(\d+)/).map{ |x| x[0].to_i }.max].compact.max'
$replacement_file = $PSScriptRoot + "\eventlog_rb_replacement.txt"
$replacement = (Get-Content $replacement_file) -join("`r`n")

(Get-Content $eventlog_rb).replace($needle, $replacement) | Set-Content $eventlog_rb


##############################
#  STEP 5 - COPY NECESSARY DLL FILES.
##############################
# Save the C++ runtime DLL to allow running gems with C++ native extensions
# such as winevt_c.
$libstd_cpp_dll = $RUBY_DEV_DIR + "\mingw32\bin\libstdc++-6.dll"
cp $libstd_cpp_dll $SD_LOGGING_AGENT_DIR\bin


##############################
#  STEP 6 - REMOVE UNNECESSARY FILES.
##############################
rm -r -Force $RUBY_DEV_DIR


##############################
#  STEP 7 - ZIP THE FILES.
##############################

rm -Force $STACKDRIVER_ZIP -ErrorAction Ignore
Add-Type -Assembly System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($SD_LOGGING_AGENT_DIR, $STACKDRIVER_ZIP)


##############################
#  STEP 8 - INSTALL NSIS.
##############################

# Install NSIS and wait for it to finish.
& $NSIS_INSTALLER /S /D=$NSIS_DIR | Out-Null

# Unpack the nsis unzip plugin.
[System.IO.Compression.ZipFile]::ExtractToDirectory($NSIS_UNZU_ZIP, $NSIS_UNZU_DIR)

# Copy the needed DLL from the NSIS plugin into the NSIS pluging directory.
cp $NSIS_UNZU_DLL $NSIS_UNICODE_PLUGIN_DIR


##############################
#  STEP 9 - COMPILE THE NSIS SCRIPT.
##############################

& $NSIS_MAKE /DVERSION=$version $STACKDRIVER_NSI

Set-PSDebug -Trace 0
