class Xcinfo < Formula
  desc "Tool to get information about and install available Xcode versions"
  homepage "https://github.com/XcodeReleasesOrg/xcinfo"
  url "https://github.com/XcodeReleasesOrg/xcinfo/archive/refs/tags/2.0.0.tar.gz"
  sha256 "978a6eadd80fc802060226909137f1b035159d8b71c58d8f78c91abcc95e78f7"
  license "LGPL-3.0-only"
  head "https://github.com/XcodeReleasesOrg/xcinfo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97446589d632f7930427c63503c58f7f90da7159f0ff36c7ad566976726d204e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06c95ac7068fc693c5c85a800a6dee06ab1705393efcc2f275f93c1f113bcb57"
  end

  depends_on xcode: ["27.0", :build]
  depends_on arch: :arm64
  depends_on macos: :tahoe # aligned to build Xcode as cannot cross-compile

  def install
    # The default SwiftBuild build system fails to compile swift-syntax's C shims in the Homebrew build environment
    system "swift", "build", "--build-system", "native", *std_swift_args
    bin.install ".build/release/xcinfo"
  end

  test do
    (testpath/"Xcode.xip").write "not an archive"
    output = shell_output("#{bin}/xcinfo extract #{testpath}/Xcode.xip -i #{testpath} --json 2>&1", 6)
    assert_match "Xcode.xip is not a .xip or .aea archive.", output

    assert_match version.to_s, shell_output("#{bin}/xcinfo --version")
  end
end
