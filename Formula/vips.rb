class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.5.5/vips-8.5.5.tar.gz"
  sha256 "0891af4531d6f951a16ca6d03020b73796522d5fcf7c6247f2f04c896ecded28"

  bottle do
    sha256 "125ff0462395a3159a2b8ffe750a6adea11b271458446eae00b4018346ed860c" => :sierra
    sha256 "a9042423e275380896d5919b9db919dd71106ce355f7da5f6b11a83bac08a61a" => :el_capitan
    sha256 "adad586a8bda37ac58d394cd5fa66e19fc084b1dfd789fe6fd64e62f3ea9e9fd" => :yosemite
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
