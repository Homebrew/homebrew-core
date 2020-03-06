class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-4.3.0.tar.gz"
  sha256 "f739859bc04f38735591be2f75009b98a2359033675ae310dffc3114a17ccf89"
  revision 5

  bottle do
    cellar :any
    rebuild 1
    sha256 "2af02146b2f560166f748cf634bf56e7b6a0acf8723fceba8c15e8099a55511e" => :catalina
    sha256 "056e46dfbe2f0823b251664e24a66417e8297cab5689113dff1b3b7383575447" => :mojave
    sha256 "ea0094723dd6ea46ca4f1de0ac341afcef5b94ede6784dcffe97431bb5adbaec" => :high_sierra
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
