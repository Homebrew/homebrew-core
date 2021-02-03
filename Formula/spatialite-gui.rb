class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-only"

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(-beta\d)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2d788de8857d609356ce8b97b87b1838940757834aa1333e1281d5f13f23cb83"
    sha256 cellar: :any, big_sur:       "3656d32601beec4051e857d755da2d83ebd136382ee32bda4492b04ee4eb7b42"
    sha256 cellar: :any, catalina:      "fd3dd58b7818d298d1ee682270e124d25fd92bb7017a05d53dcf45ebf53f1e23"
    sha256 cellar: :any, mojave:        "13c864fd247e27bc67c69047d7b175b1e6913cadff426ddf2267754ea1dee278"
    sha256 cellar: :any, high_sierra:   "dc96081a458992e1fbefc8cb9c93d285596d1ad2844367fd84c0679bd4e175d3"
  end

  depends_on "pkg-config" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "libgaiagraphics"
  depends_on "libspatialite"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "wxmac"

  def install
    # Link flags for sqlite don't seem to get passed to make, which
    # causes builds to fatally error out on linking.
    # https://github.com/Homebrew/homebrew/issues/44003
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    # Use Proj 6.0.0 compatibility headers
    # https://www.gaia-gis.it/fossil/spatialite_gui/tktview?name=8349866db6
    ENV.append_to_cflags "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
