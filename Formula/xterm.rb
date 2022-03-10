class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-372.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_372.orig.tar.gz"
  sha256 "c6d08127cb2409c3a04bcae559b7025196ed770bb7bf26630abcb45d95f60ab1"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "03051d80772edf1fb1fd7c94299c774488317d4f960aac9b0b379a172c69870a"
    sha256 arm64_big_sur:  "3d73b5319fcb75a64a4e0b2d090092781f3e04cd627a891fa77291983e4507f1"
    sha256 monterey:       "4a9e6a2265f5debf7685a365691dc01f1a412cbf8558c1535d68c0c1395caf41"
    sha256 big_sur:        "090b6cf967b7b6cf280ab86cb9620ac1756d4a96eb19c876edf8cdee40f0888a"
    sha256 catalina:       "a1b102e321daaa1ad6b39c365aec783fd7449c1db6cca5e09fb56ecc792d054a"
    sha256 x86_64_linux:   "e2842a221fa05f7dbf51cd2a86e5349ed6f1d5eb41f15e6ba42900928c83f365"
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
