class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.7.2/vips-8.7.2.tar.gz"
  sha256 "66c8d1f1db1d0934091e101abe8b3de552f45fb03d120dc10aa15450058d4baa"
  revision 1

  bottle do
    sha256 "0af014d20d528dbdff5f7c680419ab15cd57da114d85ea1bb8ceaf066f3dd5c3" => :mojave
    sha256 "f2c9b7f718c8bfce4be10563b4e56961f1ed172dcffa974e46773481e4d788a8" => :high_sierra
    sha256 "6273864ad44f4f1224313eceeb9faae9e19053a23ddf31a05104608183cf6a56" => :sierra
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
