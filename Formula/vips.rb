class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.6.1/vips-8.6.1.tar.gz"
  sha256 "f9ba6235ebc3e4d20af5f1604436bcd9686a3fecbe40838325d542f0c21a9270"

  bottle do
    sha256 "99949b900ffe3b260187ff17d22fa46e73204129f8347c3287066151f1af07a6" => :high_sierra
    sha256 "5f4f10fbe19a81c85825c5fd124b6e002875ee07cf154f4a1ad5e1224f4d59c8" => :sierra
    sha256 "2a41fc07077362bd2eeb0f9af8b870f5e4e5369bd367686e0a69e1fb3b20c051" => :el_capitan
  end

  depends_on "pkg-config" => :build
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
  depends_on "pygobject3"
  depends_on "fftw" => :recommended
  depends_on "poppler" => :recommended
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
