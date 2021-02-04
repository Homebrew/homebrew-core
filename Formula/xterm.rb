class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-365.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_365.orig.tar.gz"
  sha256 "d627d2b005803b4ebcdf04f2d89e3e1d2878235d2ecdfa73d904bb1772a74f90"
  license :cannot_represent

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "feedc30fa7545317fcd21891a8107287d3141454266b316ae3316874e545a3de"
    sha256 big_sur:       "c60885eba8c6f0cf1197793dd0fb82ec3cfec9aa7e234e90920cf4cf3fe62b7b"
    sha256 catalina:      "5d74ee6b4b620a1d7193686d1050c901f65219ecd0e36abcabdabd9c2959268f"
    sha256 mojave:        "ab6cf49a29e28028be468d0a1dc9bae2e832f9547b4d489aebe6eef5ede2ee60"
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
