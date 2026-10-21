class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 16

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "93fdbd18e22cb0a45a427a779cad02ed4232ff2f45cae78120fdb50fe2030aa0"
    sha256 cellar: :any, arm64_tahoe:       "28181f5f00cb7a61259dbbfd43367c5dab14b8b5c14de96b06aa75d25b3a651c"
    sha256 cellar: :any, arm64_sequoia:     "c7b839f7ff8b73db523941bd65bbed24f1b611c271aad397b1389a16b0200ced"
    sha256 cellar: :any, arm64_linux:       "685389f23d6a6cffc260f1eb0560344c5bce96df72e9f527173cb92d52ce17b9"
    sha256 cellar: :any, x86_64_linux:      "af2931bb82097e4e0dbb1f762e73d9325e1b0404753012717da31a97ab16280a"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Link flags for sqlite don't seem to get passed to make, which
    # causes builds to fatally error out on linking.
    # https://github.com/Homebrew/homebrew/issues/44003
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    args = ["--with-wxconfig=#{wx_config}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # spatialite_gui has no headless mode; initialising wxWidgets needs WindowServer
    # access on macOS, which the test sandbox denies.
    assert_path_exists bin/"spatialite_gui"
    return if OS.mac?

    # Without a display, wxGTK fails to initialise after all shared libraries are loaded
    ENV.delete "DISPLAY"
    ENV.delete "WAYLAND_DISPLAY"
    output = shell_output("#{bin}/spatialite_gui 2>&1", 255)
    assert_match "Unable to initialize GTK+, is DISPLAY set properly?", output
  end
end
