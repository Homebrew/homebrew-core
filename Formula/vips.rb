class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.12.2/vips-8.12.2.tar.gz"
  sha256 "565252992aff2c7cd10c866c7a58cd57bc536e03924bde29ae0f0cb9e074010b"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "0e9d0479d01b08754283b695427a7c1aa36beffb567c07e25fdac8a2685f7649"
    sha256 arm64_big_sur:  "4c2b975f8a4f7a9e6e1ca1b50fcc66c52a2b5f257a48d1fef828c487f26334b2"
    sha256 monterey:       "eb519980dbd7e7c42e7f7731be36838b5d279f95e2b7cbc4c8c7fa17df13c7d9"
    sha256 big_sur:        "e824f02d4b151c8b5004f64132965dfccd1bd13040f021346df0aedd52c70ca4"
    sha256 catalina:       "77dfb217bd6b4b0dd1292fe29f8021bf4bb8333523a8715ac4f4467a8e29f94a"
    sha256 x86_64_linux:   "a02853a50059059c308a93900839afb5fb4fbc3b0b5cb96a0f6535db085ad5eb"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "cgif"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "hdf5"
  depends_on "imagemagick"
  depends_on "imath"
  depends_on "jpeg-xl"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libheif"
  depends_on "libimagequant"
  depends_on "libmatio"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libspng"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "little-cms2"
  depends_on "mozjpeg"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openslide"
  depends_on "orc"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
    depends_on "gobject-introspection"
  end

  fails_with gcc: "5"

  def install
    # mozjpeg needs to appear before libjpeg, otherwise it's not used
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["mozjpeg"].opt_lib/"pkgconfig"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp

    # --trellis-quant requires mozjpeg, vips warns if it's not present
    cmd = "#{bin}/vips jpegsave #{test_fixtures("test.png")} #{testpath}/test.jpg --trellis-quant 2>&1"
    assert_equal "", shell_output(cmd)

    # [palette] requires libimagequant, vips warns if it's not present
    cmd = "#{bin}/vips copy #{test_fixtures("test.png")} #{testpath}/test.png[palette] 2>&1"
    assert_equal "", shell_output(cmd)
  end
end
