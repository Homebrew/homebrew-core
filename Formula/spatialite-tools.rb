class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-5.0.1.tar.gz"
  sha256 "9604c205e87f037789bc52302c66ccd1371c3e98c74e8ec4e29b0752de35171c"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/"
    regex(/href=.*?spatialite-tools[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae74cc99ac7a4b6bb712479f4b78ca3e2948c22bc5f3274e6e393f895203bd9b"
    sha256 cellar: :any,                 arm64_monterey: "b86e6782ee3e213e0f48dff798cfb97abe3d7b70b9952adec27a38101ae79ad0"
    sha256 cellar: :any,                 arm64_big_sur:  "85f55f7e24e468d2e8c4e12b756adb403c7dca4c7d876ffa6f4d137068281bb7"
    sha256 cellar: :any,                 ventura:        "ea4eb6399d740f3b6c7ee6afc7c8068482a1047969d2e53fe30a4ba177cf2c15"
    sha256 cellar: :any,                 monterey:       "a48217b08cf43cb0ab8f3d4d04746039aed59f2e6ab94da257086640cc554809"
    sha256 cellar: :any,                 big_sur:        "14b4e9a726e60acf5e1e1fee927c95ac8956b616882e689010dd9c0f13e19675"
    sha256 cellar: :any,                 catalina:       "73a69a00307ae7198b57f8e9636be6c096364366ab0e6641aed513a2fc88022f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b23dd8401a4f5979eb7f4d4356fe0a6254097d7312ceb4d9261bdce49593d9cf"
  end

  depends_on "pkg-config" => :build
  depends_on "libspatialite"
  depends_on "proj"
  depends_on "readosm"

  def install
    # See: https://github.com/Homebrew/homebrew/issues/3328
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    # Ensure Homebrew SQLite is found before system SQLite.
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"spatialite", "--version"
  end
end
