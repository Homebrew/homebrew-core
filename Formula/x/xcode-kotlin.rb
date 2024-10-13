class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin.git",
    tag:      "2.0.0",
    revision: "8c775c45071beb96baa86dcafc11c5fe44987750"
  license "Apache-2.0"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ef75f3102ac004ff31ac564b25d29d8c42f900b7879af9ec89389f5de07bf42d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd8a6748627084b0beeef05aaeb7776adba872990e8a7bdba89d763638db96f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c1ee6826b0c5c38bbe8cbd90473c7fdf8d667213cacc1ddcf892a55e5e6ec31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "802f0d2b7827e4234dd8088bae91598794cc7c0059f496a309d57f696089097b"
    sha256 cellar: :any_skip_relocation, sonoma:         "380cc1c8851372658c2e73e2b5d2c64544c47ed9ed6e192313b3d57c3b904d01"
    sha256 cellar: :any_skip_relocation, ventura:        "b44b3a7ff866d6b6914395241810c12a4616e463173ac8bf5247ade71f5d1daa"
    sha256 cellar: :any_skip_relocation, monterey:       "b5a51fbb58816599e22e9efb6b2a11172ce28457e13b6c20601398d175d33254"
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
