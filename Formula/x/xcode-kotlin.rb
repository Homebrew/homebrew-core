class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin.git",
    tag:      "1.3.1",
    revision: "595d5b0bca5e56362abbb2e0ca11de4020392f4f"
  license "Apache-2.0"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bb02ca24ea211322ab73a829dd82056ab51045ce86241239a6bd8b6f7147b38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10a1bef60f5bff99f07eac8f8f638ece20a70be8997d890779d2c1049f675a1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cb99bff69b8d12c35c30e5363bc39586cc502c05e76c25e8eebc87249c54ba3"
    sha256 cellar: :any_skip_relocation, sonoma:         "65fd44b5c04141239380d8e0f203f0ddb99b63fce499879cffa512336bfd5111"
    sha256 cellar: :any_skip_relocation, ventura:        "09121f1f8f89b5be892f2a04300d4368dcbd8b15a820291c3922bfeb846eaf96"
    sha256 cellar: :any_skip_relocation, monterey:       "cfdb490e0cc99f0e9b0c447ac2e3987ce7d388a3a0a2ec5680c69f0d12666f6e"
  end

  depends_on "gradle" => :build
  depends_on xcode: ["12.5", :build]
  depends_on :macos

  def install
    suffix = (Hardware::CPU.arch == :x86_64) ? "X64" : "Arm64"
    system "gradle", "--no-daemon", "linkReleaseExecutableMacos#{suffix}", "preparePlugin"
    bin.install "build/bin/macos#{suffix}/releaseExecutable/xcode-kotlin.kexe" => "xcode-kotlin"
    share.install Dir["build/share/*"]
  end

  test do
    output = shell_output(bin/"xcode-kotlin info --only")
    assert_match "Bundled plugin version:\t\t#{version}", output
    assert_match(/Installed plugin version:\s*(?:(?:\d+)\.(?:\d+)\.(?:\d+)|none)/, output)
    assert_match(/Language spec installed:\s*(?:Yes|No)/, output)
    assert_match(/LLDB init installed:\s*(?:Yes|No)/, output)
    assert_match(/LLDB Xcode init sources main LLDB init:\s*(?:Yes|No)/, output)
  end
end
