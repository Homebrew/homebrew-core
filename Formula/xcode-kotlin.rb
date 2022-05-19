class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin.git",
    tag:      "1.2.1",
    revision: "38fcfe98b84453b4f93040609a15a947f0fe5ce9"
  license "Apache-2.0"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e30d401858e6d92ff0812cd7306ee1f1febc528ca4facec6ef1fa6d71c0ad616"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "154c6668f7672acecf84c615558ef0a5f0ac3f8f7b351dce0dcb54f01fbb848f"
    sha256 cellar: :any_skip_relocation, monterey:       "59ffda73313c0df249b5eacdd04e3ef5f20c45d058a8bfea0b27ec641d1f071e"
    sha256 cellar: :any_skip_relocation, big_sur:        "24d77505f997ff6ddbe52c1cb01f4c30b559663e86d9bbc40606be9e2ae63d03"
  end

  depends_on "gradle" => :build
  depends_on xcode: ["12.5", :build]
  depends_on :macos

  def install
    suffix = Hardware::CPU.arch == :x86_64 ? "X64" : "Arm64"
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
