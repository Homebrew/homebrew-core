class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "188f81b97802e6efecab2e732286bb55a4921583f9530b23d5704018af066163"
    sha256 cellar: :any,                 arm64_big_sur:  "9e93bc5d9e5abb0b4ee0014b8bcb31e9c53c061275b67ba8f3a7b2154bf7874f"
    sha256 cellar: :any,                 monterey:       "53a54a20347a6ed3187ab6fe828e2fb18db29b46a47e01eb2927d373592541da"
    sha256 cellar: :any,                 big_sur:        "00a4e76ad5042b7ed6585f3d04c257a2cc5d99dbd03be3cee9dffd5d2bd762e3"
    sha256 cellar: :any,                 catalina:       "b92d965c653a495c1f98f69a69630311ea0cca6ec2fbd3f48fef844b5b8a70f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6bbb4df133233357685337ce89840274ea01d61da52c8af8f91732417a356ee"
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
  depends_on "wxwidgets@3.0"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    wxwidgets = Formula["wxwidgets@3.0"]

    # Link flags for sqlite don't seem to get passed to make, which
    # causes builds to fatally error out on linking.
    # https://github.com/Homebrew/homebrew/issues/44003
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    system "./configure", "--prefix=#{prefix}",
           "--with-wxconfig=#{wxwidgets.opt_bin}/wx-config-#{wxwidgets.version.major_minor}"
    system "make", "install"
  end
end
