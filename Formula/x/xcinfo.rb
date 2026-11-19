class Xcinfo < Formula
  desc "Tool to get information about and install available Xcode versions"
  homepage "https://github.com/XcodeReleasesOrg/xcinfo"
  url "https://github.com/XcodeReleasesOrg/xcinfo/archive/refs/tags/2.1.0.tar.gz"
  sha256 "4e40836ceaff4a3f96c15244fc18be8fcaed1ca55f769fcec53b4ace354cf21d"
  license "LGPL-3.0-only"
  head "https://github.com/XcodeReleasesOrg/xcinfo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5829ab2c8dd3a832f2f082194d89d643b3f61fb4d6c49745d2f5c2bb41361d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7fbbf4d45bbcdcf2f563e7cd1b36db960b94cfd9127dc28eded8487cb35b7451"
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
