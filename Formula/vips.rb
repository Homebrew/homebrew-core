class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.5.5/vips-8.5.5.tar.gz"
  sha256 "0891af4531d6f951a16ca6d03020b73796522d5fcf7c6247f2f04c896ecded28"

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "glib"

  depends_on "fftw" => :recommended
  depends_on "giflib" => :recommended
  depends_on "gobject-introspection" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libexif" => :recommended
  depends_on "libgsf" => :recommended
  depends_on "libpng" => :recommended
  depends_on "librsvg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "little-cms2" => :recommended
  depends_on "orc" => :recommended
  depends_on "pango" => :recommended
  depends_on "poppler" => :recommended
  depends_on "pygobject3" => :recommended
  depends_on "python" => :recommended

  depends_on "graphicsmagick" => :optional
  depends_on "imagemagick" => :optional
  depends_on "jpeg-turbo" => :optional
  depends_on "mozjpeg" => :optional
  depends_on "openexr" => :optional
  depends_on "openslide" => :optional
  depends_on "python3" => :optional
  depends_on "webp" => :optional
  depends_on "homebrew/science/cfitsio" => :optional
  depends_on "homebrew/science/c" => :optional
  depends_on "homebrew/science/libmatio" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--with-magick" << "--with-magickpackage=GraphicsMagick" if build.with? "graphicsmagick"

    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    system "#{bin}/vipsheader", test_fixtures("test.png")
  end
end
