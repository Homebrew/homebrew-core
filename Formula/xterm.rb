class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-375.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_375.orig.tar.gz"
  sha256 "302c59a2bf81e79c6a701525d778161a218d1239f21568d89e2bdd31c015217f"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "571f8227faca411181776371f4306592402c7a040b6ca56d11a80c8aebf8c65a"
    sha256 arm64_monterey: "02241b30223ca77d9058f746ac28b5fffd40bd336d171451234ea7cd32bc939b"
    sha256 arm64_big_sur:  "6d5d31a3399e92b56be536ad7ef50ee7f79b9a4d35e8060413096d2993a38b32"
    sha256 ventura:        "980addb43555f2aa6a42e5049d3079695d04a2a7f40790ed2f6a7ebec0f2bf8f"
    sha256 monterey:       "068fa0fdea084014064eb02af285ba676ce2710823d156d9be6c9aeb2096a9be"
    sha256 big_sur:        "fb5eb44f9fbfe90a588bfd84226501ec8db3e74de6e8b2a22558b31ce7863313"
    sha256 catalina:       "49ebeb6f06569feca68730728c68a9f3f97133a19ec9b19c15354a1931d2c9ca"
    sha256 x86_64_linux:   "07f6668ac47a84e3012f7d82472123586070a9cec744951516d4251577fd4a93"
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
