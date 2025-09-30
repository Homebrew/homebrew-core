class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin/archive/refs/tags/2.2.1.tar.gz"
  sha256 "3789d886022509cb232616679835a7dd67e4adb4983a24f1ce268aa244978aa8"
  license "Apache-2.0"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8432e2d622a06bacb457053e063480f63879c3e73abf22fe40b3114291ad881"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d3b032937ee2f5e72a80cff85d9bb0b257178e6498b050f3f45919910c7bc77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e21566ddcf5a53e5f3320fe660a0b6c67d70a6ed3e6fc5ca82b72087ed80d7db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "693d8c42c635a9560ceb4ca9e6a9512123fbada905b3068deef8e38f4340a355"
    sha256 cellar: :any_skip_relocation, sonoma:        "95af928c785a49d772eef8755d4854e7a89f5f8179a65dd0a5b2e512c63d0eb6"
    sha256 cellar: :any_skip_relocation, ventura:       "2386514c4fbb8166b6e9ed4f016abecef6a69a8684ad84d890db0f9b66b36021"
  end

  depends_on "gradle" => :build
  depends_on xcode: ["12.5", :build]
  depends_on :macos

  def install
    suffix = Hardware::CPU.intel? ? "X64" : "Arm64"
    system "gradle", "--no-daemon", "linkReleaseExecutableMacos#{suffix}", "preparePlugin"
    bin.install "build/bin/macos#{suffix}/releaseExecutable/xcode-kotlin.kexe" => "xcode-kotlin"
    share.install Dir["build/share/*"]
  end

  test do
    output = shell_output("#{bin}/xcode-kotlin info --only")
    assert_match(/Bundled plugin version:\s*#{version}/, output)
    assert_match(/Installed plugin version:\s*(?:(?:\d+)\.(?:\d+)\.(?:\d+)|none)/, output)
    assert_match(/Language spec installed:\s*(?:Yes|No)/, output)
    assert_match(/LLDB init installed:\s*(?:Yes|No)/, output)
    assert_match(/LLDB Xcode init sources main LLDB init:\s*(?:Yes|No)/, output)
  end
end
