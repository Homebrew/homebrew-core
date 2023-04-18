class Unxip < Formula
  desc "Fast Xcode unarchiver"
  homepage "https://github.com/saagarjha/unxip"
  url "https://github.com/saagarjha/unxip.git",
      tag:      "v2.1",
      revision: "6cd33413f0e341b201badb707ac7d4c64c48399b"
  license "LGPL-3.0-only"
  head "https://github.com/saagarjha/unxip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39ff60aeeaf96a3a5cecddec864903d03590ae039a14bc54ec56147ecffe16dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c53d2930a7393720479e785532da3528b4f8237c85c7d030381b164cf036cb9"
    sha256 cellar: :any_skip_relocation, ventura:        "d216123b98e2af05bf3753173c6c6180a43b42aaa494bfe6059843264bd89fb7"
    sha256 cellar: :any_skip_relocation, monterey:       "63f436dd340d2ea9e1f05061ecdb84bd1926f27cecbc08d86cc87535a33d1fd6"
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
