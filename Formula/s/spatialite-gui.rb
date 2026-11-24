class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 17

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  bottle do
    manifest_sha256 "ede6bd1fb84991b280e0f8ced3412e8f28a8a02ddb3dcda0aff7a5f5d982ab01"
    sha256 cellar: :any, arm64_golden_gate: "f84911fbfd5c14dfa19a845bcc4afe84a44da9c9544a69164c12dd22d46105de"
    sha256 cellar: :any, arm64_tahoe:       "0279bbfd5b7ed42c3608eda754e488c8ee6f713f228bb8835c4a6525e83d2dd5"
    sha256 cellar: :any, arm64_sequoia:     "c3c3b53196d2c4c5168c3d6c152285c2faebe7396234e8e0510978d46280474c"
    sha256 cellar: :any, arm64_linux:       "883ef477c8d412fc078ee19a1c2b9824379ee6617e3c802dc2b0f68151591ccd"
    sha256 cellar: :any, x86_64_linux:      "43ee25b8f2900b684ebc4991676eea0e4e449e9ad85d8be8dbe8a044adc9a026"
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

    wxwidgets = dep("wxwidgets").to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    args = ["--with-wxconfig=#{wx_config}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

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
