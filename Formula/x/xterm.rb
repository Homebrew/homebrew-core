class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-393.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_393.orig.tar.gz"
  sha256 "dc3abf533d66ae3db49e6783b0e1e29f0e4d045b4b3dac797a5e93be2735ec7b"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "bd3bdc3caa7ee7c107e1536fb21cb17cdcc98f8244a0acccb41ae96a941c56a5"
    sha256 arm64_ventura:  "974aab9c978fd5a6dc19a9bb59e7a36806d000cd06cab8d498a8d5c87ad3fa2c"
    sha256 arm64_monterey: "19af71c0910dbe62004c4cca2b6eda8cff674c035dc7fc1d370d9f50cf285f50"
    sha256 sonoma:         "83e820334b8643ca0fd6f5b478a65a1a2996b0437caf0b8f45d23a71b103f268"
    sha256 ventura:        "4304b6be28bd02eb2fc08abb13ee673b565be702c2307b40f4696c9c2e39cdef"
    sha256 monterey:       "38691a4cdddde703efb13543fd244e55e89f249ccbe1b4f4d34898976e9f33fa"
    sha256 x86_64_linux:   "49a3b9f3f0a83b45e18bf9b7960d5e8aaa7d3eff4211bbe2b4f137e9dd7baa61"
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_predicate bin/exe, :exist?
      assert_predicate bin/exe, :executable?
    end
  end
end
