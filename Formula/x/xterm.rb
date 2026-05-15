class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-410.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_410.orig.tar.gz"
  sha256 "7ba9fbb303dd3d95d06ca24360d019048d84e5822dc6fe722cd77369bdbf231f"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c5aa165bd88ee7866df89dd401908fe5f1755d6a0ab9ffaec60d26ba09f876e6"
    sha256 arm64_sequoia: "9974d192ac3af58d80ade6596688a3cbf8bc7b0de338116e2d09881e6a39cc86"
    sha256 arm64_sonoma:  "fe6d5091e4738b04a7f3b68338c8626649281c8c489ff06d34b2c25842ca32b2"
    sha256 sonoma:        "7990f68af0367db942abc793b9dccab1ca34047435bd50c338d526e6357dd5bf"
    sha256 arm64_linux:   "cb05013397746dfbbe2659e98be445dc22fddab388fc726dd34be1a0d1dd1162"
    sha256 x86_64_linux:  "bd079476fc2828261211d348c9c4ddebdc5560c1ed7bed3ec5e38b97077631b4"
  end

  depends_on "pkgconf" => :build
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
      assert_path_exists bin/exe
      assert_predicate bin/exe, :executable?
    end
  end
end
