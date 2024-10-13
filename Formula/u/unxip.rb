class Unxip < Formula
  desc "Fast Xcode unarchiver"
  homepage "https://github.com/saagarjha/unxip"
  url "https://github.com/saagarjha/unxip/archive/refs/tags/v3.0.tar.gz"
  sha256 "3e2b841eb06462110a83f90584d7e0c4bcac90de23ccd45d2eba6a29066a7e2d"
  license "LGPL-3.0-only"
  head "https://github.com/saagarjha/unxip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e258056cbfae75aceca91e4cceb40bc97f5c82102b09263a8e6825dc2d8bc359"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5df678380dc576645ab13265af663404c88cef771a7edf7ca0c72e7d7d2bf22d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7946cf4496d6f0718efe70b88c95932679c00a0f4398f0d6979cbad5c4cecd91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79f5dbbcea07409b9ce470c9bff60c82d4399db176b77bc450f2900022346377"
    sha256 cellar: :any_skip_relocation, sonoma:         "0662fe63df14c1571631b8f4e57381045e93d7f4269dc7e0b1c6d95bcaabc4d4"
    sha256 cellar: :any_skip_relocation, ventura:        "0fdd0cc7f70a1ebc9181687ebbdff2401a7f7a8e3e11aa50e7d0c8f58748097d"
    sha256 cellar: :any_skip_relocation, monterey:       "039ceba020c663073c09912b6c25230a4735cff3bf775074e5d3e4bba5591c1d"
  end

  depends_on macos: :monterey

  uses_from_macos "swift"

  # Uses Compression framework on macOS
  on_linux do
    depends_on "xz"
    depends_on "zlib"
  end

  def install
    args = %w[--disable-sandbox --configuration release]
    args += %W[-Xcc -I#{HOMEBREW_PREFIX}/include -Xlinker -L#{HOMEBREW_PREFIX}/lib] if OS.linux?

    system "swift", "build", *args
    bin.install ".build/release/unxip"
  end

  test do
    assert_equal "unxip #{version}", shell_output("#{bin}/unxip --version").strip
    # On Linux we don't have `xar` or XAR support in `libarchive`
    return if OS.linux?

    # Create a sample xar archive just to satisfy a .xip header, then test
    # the failure case of expanding to a non-existent directory
    touch "foo.txt"
    system "xar", "-c", "-f", "foo.xip", "foo.txt"
    assert_match %r{^Failed to access output directory at /not/a/real/dir.*$},
      shell_output("2>&1 #{bin}/unxip foo.xip /not/a/real/dir", 1)
  end
end
