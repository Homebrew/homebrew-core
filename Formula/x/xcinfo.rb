class Xcinfo < Formula
  desc "Tool to get information about and install available Xcode versions"
  homepage "https://github.com/XcodeReleasesOrg/xcinfo"
  url "https://github.com/XcodeReleasesOrg/xcinfo/archive/refs/tags/2.0.0.tar.gz"
  sha256 "978a6eadd80fc802060226909137f1b035159d8b71c58d8f78c91abcc95e78f7"
  license "LGPL-3.0-only"
  head "https://github.com/XcodeReleasesOrg/xcinfo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3df6418afc61ae23e1f303b405cdf6c24dff3a0fed304e1a0a7ba9e59be44e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f8d2172793446ab5a5a0e67c2257a6e7037223c9321e0f1db04dec6c84d16ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "209fabe73333978156fc9bf344645a62b1eaeaa5c9fa872ce52993f4b1717533"
    sha256 cellar: :any_skip_relocation, ventura:       "f3b5b7c1fa92151ca33febdc63092f6af054f3c8bd7f9b5fb668157bf139b19d"
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
