class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.7/sylpheed-3.7.0.tar.bz2"
  sha256 "eb23e6bda2c02095dfb0130668cf7c75d1f256904e3a7337815b4da5cb72eb04"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MIT", :public_domain]
  revision 7

  livecheck do
    url "https://sylpheed.sraoss.jp/en/download.html"
    regex(%r{stable.*?href=.*?/sylpheed[._-]v?(\d+(?:\.\d+)+)\.t}im)
  end

  bottle do
    sha256 arm64_sonoma:   "b495ed0f57f6d69fb00f2295e90114d2f84383bea9265b7745a5879d93c8b28f"
    sha256 arm64_ventura:  "ae1224cc9e932e455ce0beabf837e2e461ebc3c94e12dfe0049a27b2ab5fbbaf"
    sha256 arm64_monterey: "8a61d3c007130922a3401fa21126224af1150e42c0505a71b001025a339104e9"
    sha256 sonoma:         "318cdef672289eef299f997f611bdb0b04289a2df140f11f486750d1e9caee2f"
    sha256 ventura:        "90d177673ba7c5cbcc5379ff58d6fe0dfc53bfaf5d56dd83b9c5b63e897793df"
    sha256 monterey:       "5fc319eacb46d715a6d65afd9415037d51201bdd9990e8551ea2565acfec591d"
    sha256 arm64_linux:    "445fac115ea59195e3d6f635295b6f872d6eb48d62bfd82e93fab79d912b9291"
    sha256 x86_64_linux:   "2acbda751260830e9e9388a9745bc6df4668b2c3799b200335d0c19d2018882c"
  end

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gpgme"
  depends_on "gtk+"
  depends_on "openssl@3"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "libassuan"
    depends_on "libgpg-error"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-updatecheck", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"sylpheed", "--version"
  end
end
