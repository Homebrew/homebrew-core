class SwitchaudioOsx < Formula
  desc "Change macOS audio source from the command-line"
  homepage "https://github.com/deweller/switchaudio-osx/"
  url "https://github.com/deweller/switchaudio-osx/archive/1.2.1.tar.gz"
  sha256 "1be1f242cb6f720e26ac2db3949b5253e452c9e9a39a663bc2467310e259941e"
  license "MIT"
  head "https://github.com/deweller/switchaudio-osx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "516267b9a8fd17d87adb97835bcb6b42f06ff257d21ff7b8525c816b0c87803b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58397c8f25e09acd27fe9f5152554fee07badb7fb21689e99a72bc7a4b4c9106"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e02c29d3c5d249fb896d46cdb39fc62cbddf50f8b4c80e71253a10348b105059"
    sha256 cellar: :any_skip_relocation, ventura:        "487c68f1759dff53fb400e6ab8082c220ecf242613e11f2684d975a47bbd8c36"
    sha256 cellar: :any_skip_relocation, monterey:       "4e298e677f2fc7aeb5ae0693d212b2924ddde77ff0ce18b238b31722caf34ae6"
    sha256 cellar: :any_skip_relocation, big_sur:        "07a2b3014c13a4d87584ca1b21caa61597f35540f9a6ccf9c4ae94563c1d257d"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-project", "AudioSwitcher.xcodeproj",
               "-target", "SwitchAudioSource",
               "SYMROOT=build",
               "-verbose",
               "-arch", Hardware::CPU.arch,
               # Default target is 10.5, which fails on Mojave
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    prefix.install Dir["build/Release/*"]
    bin.write_exec_script "#{prefix}/SwitchAudioSource"
    chmod 0755, "#{bin}/SwitchAudioSource"
  end

  test do
    system "#{bin}/SwitchAudioSource", "-c"
  end
end
