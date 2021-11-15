class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-5.0.1.tar.gz"
  sha256 "9604c205e87f037789bc52302c66ccd1371c3e98c74e8ec4e29b0752de35171c"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/"
    regex(/href=.*?spatialite-tools[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "eb35f849a07740c11d2428ecdc269b6663a58f80387ff0b6db66f8940618f178"
    sha256 cellar: :any, arm64_big_sur:  "1dc66a96910742c330fa90b8c547ce7d7693d7c3af118707b5a15b6d6e013ef9"
    sha256 cellar: :any, monterey:       "873e89f72b1efb2b97ed66a8ef49f8eb59331075921eb21788c4ea9ea6f20dcb"
    sha256 cellar: :any, big_sur:        "1e4d449a6915bfe180238dd30ed93a2909661076a86f66cea306fda8dbdeb8c4"
    sha256 cellar: :any, catalina:       "362dd2c109f880d356d7f7e0359936717acfc1ca146277f0e2c456955c33492f"
    sha256 cellar: :any, mojave:         "ffdc8a4b476146b0f58965f3879f1418a4b151bcbe4a213a005cd5eae5ecc50f"
  end

  depends_on "pkg-config" => :build
  depends_on "libspatialite"
  depends_on "proj@7"
  depends_on "readosm"

  def install
    # See: https://github.com/Homebrew/homebrew/issues/3328
    ENV.append "LDFLAGS", "-liconv"
    # Ensure Homebrew SQLite is found before system SQLite.
    #
    # spatialite-tools picks `proj` (instead of `proj@7`) if installed
    sqlite = Formula["sqlite"]
    proj = Formula["proj@7"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3 -L#{proj.opt_lib}"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include} -I#{proj.opt_include}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"spatialite", "--version"
  end
end
