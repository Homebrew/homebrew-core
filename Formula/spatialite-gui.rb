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
    sha256 cellar: :any,                 arm64_monterey: "6de2a39b031d8ba0cd2d7c7653ecf59f348d8e32e479a430b21dc7c77c5eb0bb"
    sha256 cellar: :any,                 arm64_big_sur:  "1798e180ff29ec05b186eaae415e7277ec7d1779b0a97cf06b5c311102e0c35b"
    sha256 cellar: :any,                 monterey:       "e888e303a9f44a71d778de8fc99e6c18f3a8629310e0f99ee5db9f7529e581ad"
    sha256 cellar: :any,                 big_sur:        "04e3fce9bfefa6945a34adef96ccacd6c66bcaad8a1607bc9de447677580bda8"
    sha256 cellar: :any,                 catalina:       "670a668e9560d58127746708338d809a59f4961af89f917affc60ba8c32633e9"
    sha256 cellar: :any,                 mojave:         "3a3678ffccb6de1b99a2bf2f1f4a0b918a854bbf39d415b6e6e1c6971274c8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3ec2a26e83e966f207cc694dab91470d8215dcc650f50866f59ea20834a465c"
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
