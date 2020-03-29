class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-1.7.1.tar.gz"
  sha256 "cb9cb1ede7f83a5fc5f52c83437e556ab9cb54d6ace3c545d31b317fd36f05e4"
  revision 6

  bottle do
    cellar :any
    sha256 "fd3dd58b7818d298d1ee682270e124d25fd92bb7017a05d53dcf45ebf53f1e23" => :catalina
    sha256 "13c864fd247e27bc67c69047d7b175b1e6913cadff426ddf2267754ea1dee278" => :mojave
    sha256 "dc96081a458992e1fbefc8cb9c93d285596d1ad2844367fd84c0679bd4e175d3" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "libgaiagraphics"
  depends_on "libspatialite"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "wxmac"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/spatialite-gui/1.7.1.patch"
    sha256 "37f71f3cb2b0b9649eb85a51296187b0adf2972c5a1d3ee0daf3082e2c35025e"
  end

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

    # Add aui library; reported upstream multiple times:
    # https://groups.google.com/forum/#!searchin/spatialite-users/aui/spatialite-users/wnkjK9pde2E/hVCpcndUP_wJ
    inreplace "configure", "WX_LIBS=\"$(wx-config --libs)\"", "WX_LIBS=\"$(wx-config --libs std,aui)\""
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
