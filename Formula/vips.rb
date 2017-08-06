class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.5.7/vips-8.5.7.tar.gz"
  sha256 "a6c70794a240c64dbaa0b03902d25f1f82fd2d4d657878df901f1fc98bf77bf1"
  revision 1

  bottle do
    sha256 "a22674edfa0c053e7f462bb0f06cfc181529f524c901c3f5c107e94e64cbc863" => :sierra
    sha256 "960290216f6a5f0ea4db41df47266369d28443a2c545612566ef0ad9709b257e" => :el_capitan
    sha256 "e9f637f2b977b98141baf45ef4585a9baa74dd44869eb958fd65c024baff96a3" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "orc"
  depends_on "pango"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "graphicsmagick" => :optional
  depends_on "imagemagick" => :optional
  depends_on "jpeg-turbo" => :optional
  depends_on "mozjpeg" => :optional
  depends_on "openexr" => :optional
  depends_on "openslide" => :optional
  depends_on "webp" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "graphicsmagick"
      args << "--with-magick" << "--with-magickpackage=GraphicsMagick"
    end

    args << "--without-libwebp" if build.without? "webp"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp
  end
end
