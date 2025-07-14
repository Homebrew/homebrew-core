class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 11

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12440d60c7c0bbe29851bc1f2f5468f00e2ff6018ac565c2ebf1bfc5c51525dd"
    sha256 cellar: :any,                 arm64_sonoma:  "dfa4bbbc9e08e57e551aec1d0a769ea0f4957ba3a85585219b03df4be0ccfa97"
    sha256 cellar: :any,                 arm64_ventura: "c71e24a21ac80a8d7b39d950aaed95208f0d4a13b59c167d3fd0d391bb09a385"
    sha256 cellar: :any,                 sonoma:        "7acdd0dca937f8601efdd5d9efd685a6cbfa2e98cda37a180bc07d8bb6f5f098"
    sha256 cellar: :any,                 ventura:       "7f045e58903115abfc7377ba9c341bc93a51f183fb89d217a1c62e1269131e90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7355c24beae9ffa6f64ce572faf5d04f422d759f310a7a255cebfc5906654f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70c7b2690a75bf945cd0cac7e652cf7650ed83c31beef37f3f13954a57abda94"
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
