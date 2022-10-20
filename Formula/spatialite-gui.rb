class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "73f1e25197c6c4827cbf233a4632b8085ef0058979a750d80aef5c11eca76f80"
    sha256 cellar: :any,                 arm64_big_sur:  "5918728fd8b0d18f0ea692111483c0d661a7dab1dca4af8e8d5c6ec2434cbf0b"
    sha256 cellar: :any,                 monterey:       "004c0a7798340bb9481e79d4370c33534c2ddd557c191ebb26c141bf8e878636"
    sha256 cellar: :any,                 big_sur:        "a42be0d23841e5886582fbe07ea770d3e8b21feab1ffe3aedf46f651b7ae3ed0"
    sha256 cellar: :any,                 catalina:       "65e8e797b4af25572ee1e8ddba79ca07bdc8f6c7498c58a35e40ac1d0164e870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c89aa8042df193ac0f017adc0eb54e043c4c5c338b5a09b2f270054a52e76dc1"
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
