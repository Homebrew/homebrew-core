class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 6

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0649947cd3ee27dbd8009fea92317300ff1a1cf99adca0f5fb35977911017ba9"
    sha256 cellar: :any,                 arm64_ventura:  "0bbeebf05576a7ece01e1fd84a315ea034bbdc16ede877d4f2d6dc7ef59fad4c"
    sha256 cellar: :any,                 arm64_monterey: "e7b2e65f58e68771704984b1f30601bda64ec97a21fda6ca1c61c7880a6fe10f"
    sha256 cellar: :any,                 sonoma:         "5212c9c045b11de0a9b3b88eea709089ae08c7fd07d443cc30a084b00520df37"
    sha256 cellar: :any,                 ventura:        "96461fc3eb291d99c50b1d4ad5ce7fdd19f2935decb5a34c48fb3b28b27c881a"
    sha256 cellar: :any,                 monterey:       "025447d2713be26e6a753dcf8215727df83b5b1bb9ac94f9242fea39ee1b4fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4da054619064fa91a7f6c55002b6d2d08eef58ac63040a469dfed8e7358ad746"
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
