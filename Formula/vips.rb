class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.5.6/vips-8.5.6.tar.gz"
  sha256 "19a77ab200eb0ddfcd8babab130fe43c7730880d1f1fdfbdd8def519af32c4b8"

  bottle do
    sha256 "4a0c68b0f49ce94e76f107a42a2029a2ba389c26034c714f320eaa7b5f929346" => :sierra
    sha256 "d644dc9086393b392d5ec4b35872d76361c6898b63314288f27d1bf6603a9de3" => :el_capitan
    sha256 "085895b0d5f4d05a862f833a4a9b457365fd63b73f7ad02fd8965b17bd23bc0f" => :yosemite
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

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp
  end
end
