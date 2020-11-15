class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-5.0.0.tar.gz"
  sha256 "ad092d90ccb2c480f372d1e24b1e6ad9aa8a4bb750e094efdcc6c37edb6b6d32"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/"
    regex(/href=.*?spatialite-tools[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/i)
  end

  bottle do
    cellar :any
    sha256 "bb05699d8ad329cd1bea91041220944d034d30fad259334e6aec463b586a5f20" => :catalina
    sha256 "b2513d23a40d4793d048e98e7ae4ced1f6c7fb3abf2e51718d8043440434caa7" => :mojave
    sha256 "fde1c73dc20ab4e18c28a61946c9083edee504d5c3d52f65155d22f5ce5c2dac" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libspatialite"
  depends_on "readosm"

  def install
    # See: https://github.com/Homebrew/homebrew/issues/3328
    ENV.append "LDFLAGS", "-liconv"
    # Ensure Homebrew SQLite is found before system SQLite.
    sqlite = Formula["sqlite"]
    ENV.append "LDFLAGS", "-L#{sqlite.opt_lib}"
    ENV.append "CFLAGS", "-I#{sqlite.opt_include}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"spatialite", "--version"
  end
end
