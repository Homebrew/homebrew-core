class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-4.3.0.tar.gz"
  sha256 "f739859bc04f38735591be2f75009b98a2359033675ae310dffc3114a17ccf89"
  revision 1

  bottle do
    cellar :any
    sha256 "7d142fa854f6a2ac72ac71fff9e49f7b38aa1159c252ebcffcc2d6eb47bf1f4c" => :sierra
    sha256 "f0bf05a064a003257ca3a1383987e0808ee363a10b3c0f08f7f66bc6e9623c66" => :el_capitan
    sha256 "71ba0471df80b0da6c9b449e5ad1ec47e437518163d8ff9f0039c801699f39ee" => :yosemite
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
