class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-5.1.0a.tar.gz"
  sha256 "119e34758e8088cdbb43ed81b4a6eaea88c764b0b7da19001a5514b2545501ce"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/"
    regex(/href=.*?spatialite-tools[._-]v?(\d+(?:\.\d+)+[a-z]?)\.(?:t|zip)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "069ec4b7d85f688eb77bad3c5feeca57ee0c791c666bea3413ea8ce710a5acaa"
    sha256 cellar: :any,                 arm64_sequoia: "b95d28cf596499b58e056c8036a12aa8d642dcbca6f798eeaf4d24b21b6f985b"
    sha256 cellar: :any,                 arm64_sonoma:  "e0a3160b4865ca95d21573b74f9f55a359aaa59f94fd6056530e71a19ff253ca"
    sha256 cellar: :any,                 sonoma:        "5221eae263ba51e8fa7cdf15531d3e1b8c5e3ba155778a5c5462173a2cef6c54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e62a762b38e87ffdb9843897642b86deb5efec236179c21663acf933451d3d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daae488886ac7af7caf09434e40eacc7ae30a8c9dc578f079e791440ab2d15b8"
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
