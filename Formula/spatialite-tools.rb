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
    sha256 "1542627d080bd9b955b79194087f399ecfb51c6795319cac33a3447136d69574" => :big_sur
    sha256 "d36a2b7641d0958cd0e18bd41dd97e08e91042b7552384b70af34e7e65952c4d" => :arm64_big_sur
    sha256 "fd5e08038abf520727946839c34e61eb080fe4e0d69eb2d43ff7aa1ca4b0fd91" => :catalina
    sha256 "36686d2ddec30cdd857f5c1161ddb79b2b67269fc9bc5d78eef83e50c80de89d" => :mojave
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
