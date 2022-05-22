class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin.git",
    tag:      "1.2.1",
    revision: "38fcfe98b84453b4f93040609a15a947f0fe5ce9"
  license "Apache-2.0"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f285f107b7d74b83cee5b57f309270176e40fb26a7b19a9090d467e5dc35074e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70b8e27a5a2a615a3a2ee1bbf0d929f8acdd6e9b95f26e4147bd11ce1f48e2d9"
    sha256 cellar: :any_skip_relocation, monterey:       "f23e73486a28a283674648c3bea20e8237fa6c740548dc45a90d1063b5173034"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3f93d8e5ee666bd54ed69f40d5557059a1dd1d58b8a2f6ecb4f63870d28004a"
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
