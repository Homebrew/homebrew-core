class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 10

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30502014afdc300e446646426c552f717e6b061039acd2d89cdaa823f3d3db3e"
    sha256 cellar: :any,                 arm64_sonoma:  "04e36b8d075f92617df76d1efabc5ac7a2222e79c78a6addbeff9080a49559d5"
    sha256 cellar: :any,                 arm64_ventura: "8c591e7ae73e96ebf063357071c82640eae117ac114bf71b0ade35edb426d127"
    sha256 cellar: :any,                 sonoma:        "1bb323bba375c2ef9b27d5d2ca15ab337b909e3d289be422b9ef034cf29438ec"
    sha256 cellar: :any,                 ventura:       "fb9d6957302df3eec020646651f4584fca87b138b9f53a370d0360e35cdfb02d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "578c2016eafd653ba4cc028c6e5541895c9767ffdf8686ed8e8a55bbfa3d1110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e9e1b4b42a76a2d1324cc6ed9f8fca77c953898b7338c2e1ecda9e5324ca97c"
  end

  depends_on "pkgconf" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "libpq"
  depends_on "librasterlite2"
  depends_on "librttopo"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "libxlsxwriter"
  depends_on "libxml2"
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
  uses_from_macos "zlib"

  def install
    # Link flags for sqlite don't seem to get passed to make, which
    # causes builds to fatally error out on linking.
    # https://github.com/Homebrew/homebrew/issues/44003
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    args = ["--with-wxconfig=#{Formula["wxwidgets"].opt_bin}/wx-config"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end
