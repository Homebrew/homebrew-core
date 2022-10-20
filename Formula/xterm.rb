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
    sha256 arm64_monterey: "260564401875feba34d73eb38d0f2682c42655ab270bd104ea4630920e1df43e"
    sha256 arm64_big_sur:  "150d2bcc808932050ff67de605bfc935f509d43779e1d63aa6a59ca76fe8bab2"
    sha256 monterey:       "18bdd303954686ea45f43e254bc5e0376c0bb8de77d66cf97e2191cd0193bb20"
    sha256 big_sur:        "8e250d9bac280675713faba431fae30d85ee6c7c7f240b32efa8e55aa2377a14"
    sha256 catalina:       "a5341d359a67ddc602437c92e4a3a0b1318a5d9acd5f7372e2f5cbe5be9dd827"
    sha256 x86_64_linux:   "94617bd9f226e4f1fdcc43b44063dcbc8cb7accc5a5d3ae4692360cce3be12e1"
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
