class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-5.1.0a.tar.gz"
  sha256 "119e34758e8088cdbb43ed81b4a6eaea88c764b0b7da19001a5514b2545501ce"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/"
    regex(/href=.*?spatialite-tools[._-]v?(\d+(?:\.\d+)+[a-z]?)\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a2225e7ff88a5434b9935dc47f265e045644d5efa22e4a942d32c71869833cc"
    sha256 cellar: :any,                 arm64_sonoma:  "04ec75c512a3d0c0e9aef46df243130f9c1c9e217c9605af148554a321946642"
    sha256 cellar: :any,                 arm64_ventura: "d7fbe72eae1741ce20b5fe2dcd06b257af9cb642cf706f2012a0c42e007d8b73"
    sha256 cellar: :any,                 sonoma:        "fe5c356ae405535cfb7bb9f1ac262b7e6d7178ca84396c4b34a7eb1b8778606b"
    sha256 cellar: :any,                 ventura:       "c6ac73412b33855140008c7a03d8216532f3cb91455c779d653d8c6926ea19a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f102739c6d45f16910fa2e1e31cef488345424601fdd0bd31cf42851adb48eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "670d92603126025a4964546cc86588142cb7211dbbfb9cd43a6c09e1d83fd411"
  end

  depends_on "pkgconf" => :build

  depends_on "libspatialite"
  depends_on "libxml2"
  depends_on "proj"
  depends_on "readline"
  depends_on "readosm"
  depends_on "sqlite"

  uses_from_macos "expat"

  on_macos do
    depends_on "freexl"
    depends_on "geos"
    depends_on "librttopo"
    depends_on "minizip"
  end

  def install
    # See: https://github.com/Homebrew/homebrew/issues/3328
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    # Ensure Homebrew SQLite is found before system SQLite.
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"spatialite", "--version"
  end
end
