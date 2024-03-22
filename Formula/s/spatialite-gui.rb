class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89884971497663bdf9b7e889b94e05013d80a28084ce2be0cc8780e08fe91ec4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c536a53e5bee1a2971e50aa51eba04bbbcfc71f5ce490c06c84801eec1c822be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b7434afc44f7b02180d57580736ceb108f87d3c178f4719e2333e1c24c1988a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d3120e5b4bdd9e8a56834e2c06d304d6ccd740084e63f16fc81f384d0e1aa05"
    sha256 cellar: :any,                 sonoma:         "15aff386a158acc0f2dfc58223b613771d5427541b9cb129cd30ed899dd2adb1"
    sha256 cellar: :any_skip_relocation, ventura:        "fb28b10d6fcc6d2ae140e635dfb5055d6428b34a08a3f3a5b585441773dbe00a"
    sha256 cellar: :any_skip_relocation, monterey:       "06a2e3f898aec3797366f6ba02120434b6e97469e6331484e7edf257036110d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ca6204b4ed2605f6172eb35c206cce06171042b321ab09237d383924a4e8739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef5b135c6e6a396b28dd0516613d517615077cd9dd2bbe8477f82b9e4eb390ba"
  end

  depends_on "pkg-config" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "libpq"
  depends_on "librasterlite2"
  depends_on "librttopo"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "libxlsxwriter"
  depends_on "lz4"
  depends_on "minizip"
  depends_on "openjpeg"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "virtualpg"
  depends_on "webp"
  depends_on "wxwidgets"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    # Link flags for sqlite don't seem to get passed to make, which
    # causes builds to fatally error out on linking.
    # https://github.com/Homebrew/homebrew/issues/44003
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    system "./configure", "--prefix=#{prefix}",
                          "--with-wxconfig=#{Formula["wxwidgets"].opt_bin}/wx-config"
    system "make", "install"
  end
end
