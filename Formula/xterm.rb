class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-374.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_374.orig.tar.gz"
  sha256 "11d4d626670d4d6d7b69fb7467e9ec231817e5ad22502f9167768fd88ac1bdf5"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "db50088a7d5d877b768fca3821310aa2e780bb8ada019c61cec60b9b17e74a25"
    sha256 arm64_big_sur:  "37c47e44463d846507b5b7b4baa65ac5188990bcc1bb8bfa2f031d6a40010560"
    sha256 monterey:       "794179c013a3f3bb7d632ebbb2214509c84acba6f43ae1a6ca9d90eef15d51be"
    sha256 big_sur:        "167dc5b1b2da458d268a51980d22203bb2080902102600d9b59d5ff019fedb37"
    sha256 catalina:       "b24a3eeba111398157a97b92d9ddc5259ebedd1e658daca81ac8956cb1dc1fcf"
    sha256 x86_64_linux:   "3b3806d9a02713949cf89cae422c541d600c8ded75e35639ba56e790aa8c1aec"
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
