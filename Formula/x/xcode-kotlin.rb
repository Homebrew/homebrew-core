class XcodeKotlin < Formula
  desc "Kotlin Native Xcode Plugin"
  homepage "https://github.com/touchlab/xcode-kotlin"
  url "https://github.com/touchlab/xcode-kotlin/archive/refs/tags/2.2.0.tar.gz"
  sha256 "6b30d73e4562723b9541f82d55b56b9fa22d1cb2aae421ea95b08507c4d0d09b"
  license "Apache-2.0"
  head "https://github.com/touchlab/xcode-kotlin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "607c5ccb37298a65abbf3539b0b108ae9929ad26f6ba0a1f18ad228307650e26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b9f5572c17469472bd8c85ef33a111f50d69bbadea84bd718667f430fd9a612"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05dd704cb5e9dbdda1f8b5a5341e4919e497698783017dd558af0616d2efd115"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ba164f016a5be65f9e067d7bd018ccb423730eea3afa0eb5507c1f6381d9e53"
    sha256 cellar: :any_skip_relocation, ventura:       "929b39c1c63a5e33f400c44d39e61f53922b3d0ef37461d64358af61dc396526"
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
    output = shell_output(bin/"xcode-kotlin info --only")
    assert_match(/Bundled plugin version:\s*#{version}/, output)
    assert_match(/Installed plugin version:\s*(?:(?:\d+)\.(?:\d+)\.(?:\d+)|none)/, output)
    assert_match(/Language spec installed:\s*(?:Yes|No)/, output)
    assert_match(/LLDB init installed:\s*(?:Yes|No)/, output)
    assert_match(/LLDB Xcode init sources main LLDB init:\s*(?:Yes|No)/, output)
  end
end
