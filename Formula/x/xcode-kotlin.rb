class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin.git",
    tag:      "1.3.2",
    revision: "2a937d270f1ff286f9b87ec934b4b47b2c275909"
  license "Apache-2.0"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ade1be004b8aae16fa20d3c37c8d5ac262fd58af0250e15bbe3c27f1da43149b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c5b5587598fc9a35a3d5f45e4e75bc10bd5c869768ce43fcf03f2739af547be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c42430ed72aa1cd4c5769a164280b4cdc002723360f789bf2fb619cd5e0096eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f65d1aa248e7c893737b115f0b85a47bf4cf8277a46ee1289fd11ff155a9750b"
    sha256 cellar: :any_skip_relocation, ventura:        "3ec3640c0990f31fda0e8137bb861bdc1be17693de1c1654ddaf6b802e5070d3"
    sha256 cellar: :any_skip_relocation, monterey:       "81f9741596818ec532ac2f91d3c320265f098f7e44efa873b9cacde1f7b28979"
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
