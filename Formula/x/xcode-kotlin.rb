class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin.git",
    tag:      "1.3.0",
    revision: "0bd6303024dbacbad939d9f3f126d458a054225e"
  license "Apache-2.0"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69339f0fddf76017f1ad97cc0e276f6b74530eb4ff2d7a54516d17da529e621d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0f7980586495f08a0b40a6b8bd945ebb51b118dd8e4766f3b9ea3568a932e33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8651ca5f1d64ec6e6cc7c33327e8b386e29a028a073071661a954815d562b776"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba58e37491c17a535b333023eff8d9b197f4439b06a6feccd3e471a7016fafb9"
    sha256 cellar: :any_skip_relocation, ventura:        "3683e2bf57b6114acc7a209a28883acea95e2bbc3eb8c6e193a8ad5ac2a85f21"
    sha256 cellar: :any_skip_relocation, monterey:       "6e9592f228937c68cfa06ea3aabf0f4286f72da78cba2e0198f7f20b0e157a78"
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
