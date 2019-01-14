class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.7.3/vips-8.7.3.tar.gz"
  sha256 "03e0ed90d63b4e2d7d60ea5bd97283d0f5b1388c6c363e27ec9d34b624b6f5aa"

  bottle do
    sha256 "9628bd3b483f97730039c7ba6642cea42d3c87549537f5b6c3a5677b4cd4eb0c" => :mojave
    sha256 "af3fcb3fbf417786b58c2c0d7c98235a022e9cbde83f4b5ebd728625acdbc4d8" => :high_sierra
    sha256 "d2482e8515b7b082c4e09bf8a3e23c22047ecea22c8c0d0b9802012259ed14e1" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "graphicsmagick"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "openslide"
  depends_on "orc"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-magick
      --with-magickpackage=GraphicsMagick
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp
  end
end
