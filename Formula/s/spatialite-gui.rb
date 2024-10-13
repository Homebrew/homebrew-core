class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 7

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d4416d61f3cd5dae9afe7dd777c13856d91d807789be63c78ccd70cabd219b2c"
    sha256 cellar: :any,                 arm64_sonoma:   "239373bbb041e0934be1ce33589a1a2837de52b6a7f2287126ecc0027e837b74"
    sha256 cellar: :any,                 arm64_ventura:  "772be15226097ff551dac7f90fe4c351248e73a3816bfcfdfd03aa2d2537bd40"
    sha256 cellar: :any,                 arm64_monterey: "4ec7aac0c4c1533201f3080fda7e537ea85d6be82ee5f526309eea53b1652b36"
    sha256 cellar: :any,                 sonoma:         "680af7919f7223a71654414c55aa279ef585a47edbef54c723ea0093a97e9632"
    sha256 cellar: :any,                 ventura:        "4b743a902950f06c27bcdf54e4b17e429c3a71e9e36dd4f9c295ce653c34eb35"
    sha256 cellar: :any,                 monterey:       "085c99ebea2436fdc3830fe7367e2e8837380b6f8e7e5fb2a396b06106d88f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01964fdfdcd4ea1dea29d24210777887be81dd46ffed07a341c86a5ca932c409"
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
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(/^llvm(@\d+)?$/) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

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
