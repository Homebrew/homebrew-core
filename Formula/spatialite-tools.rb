class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-5.0.1.tar.gz"
  sha256 "9604c205e87f037789bc52302c66ccd1371c3e98c74e8ec4e29b0752de35171c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/"
    regex(/href=.*?spatialite-tools[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5e0b6d533e1d0b31e29811693464ecc895fbf7a556a233b5f4e213036f53a7a3"
    sha256 cellar: :any, big_sur:       "d7214560462a3031b23a7f0ae25ea019e44071e72a374a5621cfa4373e9db97e"
    sha256 cellar: :any, catalina:      "2be1cfd090f14eecaf18974612ee0d6c7a751c1138fd2eea6d2667098f6315cb"
    sha256 cellar: :any, mojave:        "94e72cdc9587bff34d6db75fd39eb8d94ca3992e1f94089f0eaf713d33372257"
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
