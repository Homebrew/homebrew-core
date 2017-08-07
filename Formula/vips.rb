class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.5.7/vips-8.5.7.tar.gz"
  sha256 "a6c70794a240c64dbaa0b03902d25f1f82fd2d4d657878df901f1fc98bf77bf1"
  revision 1

  bottle do
    sha256 "3f466e57cecb3e710ff3a5b60746b454f7b9c37b2a4d4c70f5ee2874328a61ef" => :sierra
    sha256 "c260bf9a715b5dc1f9ca03239062adbebb0ff539bc60dc8e06454ff8a5dd3140" => :el_capitan
    sha256 "68ad59cd3cc951a7900e309fe656874fae74bf036d9b8e9dd99ced90b37c4ecf" => :yosemite
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
