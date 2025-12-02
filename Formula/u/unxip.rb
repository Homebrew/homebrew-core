class Unxip < Formula
  desc "Fast Xcode unarchiver"
  homepage "https://github.com/saagarjha/unxip"
  url "https://github.com/saagarjha/unxip/archive/refs/tags/v3.2.tar.gz"
  sha256 "6ce48aa06d1fe06352f2937912cb43c7cd93c0a8066222af35d29d6d08130788"
  license "LGPL-3.0-only"
  head "https://github.com/saagarjha/unxip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca5e191670cf44169a204b22a239e8c10e9142baf0995959bf557831b5665a90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fa72679808308ce14aee5bf55c8d8c9080de2514705afcd8b5405ffdbfd71b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db9c5c1721975700b4b3bd8b55bb651a9fac41f8723dbad495495a5924905f34"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ca746820d1e0bfdaacd3c9b051b62239cef1c765bb1b8434461aa07d8749454"
    sha256                               arm64_linux:   "a5dab6693c7660439be128a6bf2abcbd81bacad55360c439daa4a8833f4c4315"
    sha256                               x86_64_linux:  "a0f1eaa4fd6f16d6a20b9cc5707bf569748878e60e76e849d41fddd3115b8797"
  end

  depends_on macos: :sonoma

  uses_from_macos "swift", since: :sonoma

  on_sonoma :or_older do
    depends_on xcode: ["16.0", :build]
  end

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
