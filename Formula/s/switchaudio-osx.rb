class SwitchaudioOsx < Formula
  desc "Change macOS audio source from the command-line"
  homepage "https://github.com/deweller/switchaudio-osx/"
  url "https://github.com/deweller/switchaudio-osx/archive/refs/tags/1.2.2.tar.gz"
  sha256 "3d12b57cbd6063a643a12f12287af99c87894c33449c6bcac0a71fd15776b3ed"
  license "MIT"
  head "https://github.com/deweller/switchaudio-osx.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4c957391d820920536fc088084c958dec3daad2cbc99c7c9b3e42134da4198c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d8d4c24b4029b788cdfc13bf36ddb650d220fd6fb43df0d60131c47034734f51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e6292b5cbda7b5b7dc412d6f787903cb9cdab68ad75c1a8ac0bf3e63985d782"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb34fa77825e8c7bbcceda397eea3155196039fcbafcd4e6ba419694d3f3d3b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ca3cb57b3850bc4a520e1751d4e1e9ae224df74c8c74aff0f0faba4b3b6a444"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e91921e9b3d31fbf9ee65fabf606c946a234d80af6abd418f0c68152a066d974"
    sha256 cellar: :any_skip_relocation, sonoma:         "609bfbee688f729a9451de9d76b80d403381f9448d15a5ab6f5dd3e16e05a945"
    sha256 cellar: :any_skip_relocation, ventura:        "795efb36156fe00438b1843dfd5c3d3463e3c6294b8ea96f89052b03795bcefb"
    sha256 cellar: :any_skip_relocation, monterey:       "17971fd5701812aa360ed120338fa4a9ddede0c8ec503144548614c2ebe930d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5c74d8fd8754d57165d121f02ffa338a6b721432d5694f82c555d877a946d5f"
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
    chmod 0755, bin/"SwitchAudioSource"
  end

  test do
    system bin/"SwitchAudioSource", "-c"
  end
end
