class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-4.3.0.tar.gz"
  sha256 "f739859bc04f38735591be2f75009b98a2359033675ae310dffc3114a17ccf89"
  revision 3

  bottle do
    cellar :any
    sha256 "7d0f5232b41d1471d6212ee5004904be9d330a58a3aff9b6cb9d6ab8a90a9f33" => :mojave
    sha256 "b77b197aef8f05ac1816a9fd1b262aae9fc026772cc03be67ed5be57904d65fc" => :high_sierra
    sha256 "96e80f05afa030b2646bdc60e3a466f0dcca91819890a4c5fff26f063b952db3" => :sierra
    sha256 "e20202824ce1995a371f925ed69350601a888592274a778aaec1b78a97ef3867" => :el_capitan
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
