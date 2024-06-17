class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 5

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d4392dabb5d4c3e56557cffa6fa8bf201fb0957f3b36e6ff10dda3c5f4440997"
    sha256 cellar: :any,                 arm64_ventura:  "3bcca03de6319c89394192908fca92324947083337fe1aae61eb22f440c363fd"
    sha256 cellar: :any,                 arm64_monterey: "700d4623fe0584fc17654457a2dcd830910c5fbe2ebf9dd722711907aa5103fb"
    sha256 cellar: :any,                 sonoma:         "1014b5a5eadb32b48daeb0a2a06f972b286faf03779e56cb9571559b9e403e5d"
    sha256 cellar: :any,                 ventura:        "e6884941f998ac9a3f945d76a415405553238e702e0b28aa2881fcdde07864ca"
    sha256 cellar: :any,                 monterey:       "08d7dcbb6918eb49a19844e1754c7347eb6c3d0c811e432620e7f2099257d19e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e49cf249287df161d75d0fb638bdf614e2adc2e91e72248f0f85521edeac0fbd"
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
