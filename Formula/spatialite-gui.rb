class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "794fbf81288b0abd6fbe3ace97a8e9ba13edd582937ae53682cb8e641b766441"
    sha256 cellar: :any,                 arm64_monterey: "ac51b4b7d0f131289fee8bfa741ea9d0abb8511e592c3d1db4fd3e813bd6a504"
    sha256 cellar: :any,                 arm64_big_sur:  "055eadda7cd821161c91c4e8e7d983d85c81af1ed78dcfa1ff270c7d37622e52"
    sha256 cellar: :any,                 ventura:        "d3bebe723a917f3ea31aed686206a9c20064361b14c034cf6f2beca619e17447"
    sha256 cellar: :any,                 monterey:       "53295a6df6587e44d81c579d41256b7f06552d667e32d1c6ce045cf32975ba58"
    sha256 cellar: :any,                 big_sur:        "6903cdd22316135ebb3321e27225516a03b57c065092056b4d5b8478239493ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18cd73fb4b7dc9713f0ea5bdebb1ce229e034b72ca09b1e62a4f68fda60d7d78"
  end

  depends_on "pkg-config" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "libpq"
  depends_on "librasterlite2"
  depends_on "librttopo"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "libxlsxwriter"
  depends_on "lz4"
  depends_on "minizip"
  depends_on "openjpeg"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "virtualpg"
  depends_on "webp"
  depends_on "wxwidgets"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    # Link flags for sqlite don't seem to get passed to make, which
    # causes builds to fatally error out on linking.
    # https://github.com/Homebrew/homebrew/issues/44003
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    system "./configure", "--prefix=#{prefix}",
                          "--with-wxconfig=#{Formula["wxwidgets"].opt_bin}/wx-config"
    system "make", "install"
  end
end
