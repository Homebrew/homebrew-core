class Unxip < Formula
  desc "Fast Xcode unarchiver"
  homepage "https://github.com/saagarjha/unxip"
  url "https://github.com/saagarjha/unxip.git",
      tag:      "v2.2",
      revision: "dbd4cad236901133c0bec0c54c9294a24a9f1a33"
  license "LGPL-3.0-only"
  head "https://github.com/saagarjha/unxip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf94349d691350ec8160955c2a77025c3bc63b2c401553f5eff9f32883ce4a13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c671c3fdb6be7fed02dadf61dfd2923723db45fe29fc5a8c193e260753ec687a"
    sha256 cellar: :any_skip_relocation, ventura:        "0fc3789f8da947610c5fee132d43a17de421deaea890834a5535426477618ab4"
    sha256 cellar: :any_skip_relocation, monterey:       "afe99e754d69a10def7565d2f83fa931b08a533c1fc9d71ce72854f42d5c5a53"
  end

  depends_on xcode: :build
  depends_on :macos
  depends_on macos: :monterey
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/unxip"
  end

  test do
    assert_equal "unxip #{version}", shell_output("#{bin}/unxip --version").strip

    # Create a sample xar archive just to satisfy a .xip header, then test
    # the failure case of expanding to a non-existent directory
    touch "foo.txt"
    system "xar", "-c", "-f", "foo.xip", "foo.txt"
    assert_match %r{^Failed to access output directory at /not/a/real/dir.*$},
      shell_output("2>&1 #{bin}/unxip foo.xip /not/a/real/dir", 1)
  end
end
