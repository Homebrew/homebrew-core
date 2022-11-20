class SwitchaudioOsx < Formula
  desc "Change macOS audio source from the command-line"
  homepage "https://github.com/deweller/switchaudio-osx/"
  url "https://github.com/deweller/switchaudio-osx/archive/1.1.0.tar.gz"
  sha256 "1e77f938c681b68e56187e66e11c524f2d337f54142d1cdbbd8dafec1153317d"
  license "MIT"
  head "https://github.com/deweller/switchaudio-osx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c33e14ec4b34a9514c06ab392b36c2f5fcf579aee16fed0fb02fc3a4b935ee27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6bf6a7e8873d101da1d5f24be8a8c3470af13f56ed21de847685ebf9e6efad8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "631619e7f83da181c8287e6795de8d54c03cab15bf29ba4ce5b5c0fb1f3aafcb"
    sha256 cellar: :any_skip_relocation, ventura:        "9ad594e05d7bee40a400641d34a06c59fcd2483f6e588ff98ac7faec379181a1"
    sha256 cellar: :any_skip_relocation, monterey:       "7d94bc90f9d9d0362c8fc36634170bd3e433dfd5a61b8bad3243205f4af81bec"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e6b47d1a51d71706f160ed4f19cc6fe6cacd1370eab298c029976ae6c32484e"
    sha256 cellar: :any_skip_relocation, catalina:       "59e92aaf09b86e49b6bd5f4300db02cf0812118e08146eaa2c540cb8e34b1a6b"
    sha256 cellar: :any_skip_relocation, mojave:         "e48cf16dc12a923093b4ddf5467f8234d129e5bdc15f1df1fdad30ec251e7f35"
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
