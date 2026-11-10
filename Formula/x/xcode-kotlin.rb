class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://touchlab.co/xcodekotlin"
  url "https://github.com/touchlab/xcode-kotlin/archive/refs/tags/2.2.2.tar.gz"
  sha256 "551f3f450f4fcfbddb01134e8ca666ef26a0a6144b88a654070c1ac31b064a99"
  license "Apache-2.0"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "22f392f78aae37ed58af4801eddb074dd425c8f649f1f71ca2501002e8e3e9d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d88a6e3af582f712880a1453081103f989e1e9728683547d03af4bb2bd8d245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05a57dab8857e9542897904ccecf2634101de62105caf9e3a8a65a26c7a420a7"
  end

  depends_on "gradle" => :build
  depends_on xcode: ["12.5", :build]
  depends_on :macos

  allow_network_access! :build

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
