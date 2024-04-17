class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 4

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8118deb7546c121de8bbc896903e9c72f8041743f181d519e8432f4603e2c6eb"
    sha256 cellar: :any,                 arm64_ventura:  "017848cd915bdbb235ad0274523f48bb8ee1e596e19c79eecac1fe607002bc0f"
    sha256 cellar: :any,                 arm64_monterey: "888e9f7843db07a4952db29a454302bd4ffd9161f98d2165fa3b9c0e70f9068a"
    sha256 cellar: :any,                 sonoma:         "2e6a062109a1d47a99dbd5df515fe7d45fae9b1d72f191344d5220cc40a533fc"
    sha256 cellar: :any,                 ventura:        "664b0807a162618da46d8898b8c891204ec560a128a38c26f89458c838aa64df"
    sha256 cellar: :any,                 monterey:       "2e77213707059a4cbaaa4f49639794a3c92e18950efad246381ebbfd852a63d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9dfab6ace2e591356c57306e21a5faa1f762d7ef94784a5233f652bb0043b31"
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
