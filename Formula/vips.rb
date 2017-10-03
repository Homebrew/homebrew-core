class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.5.8/vips-8.5.8.tar.gz"
  sha256 "07a3b8966a816a834dd60dc1745ae1930f3bbe604e826986a5a2bbd7f45c5426"
  revision 1

  bottle do
    sha256 "4cbcc738766cf392a0458f8e2f6f78df7193a4c6a23425a0498b47cdd9ca1286" => :high_sierra
    sha256 "6f18a2e5a7cf90c137d809258e5ffaf29ac1e8f1dd2ccce4f08edf9c99585d95" => :sierra
    sha256 "2c5c1c232a6060df5f260acc718a49949409200f36a2cd74809f227ee45a693d" => :el_capitan
    sha256 "309b17ea3fc099591ecd5c70b56657a0d31a8bb36713e7ab876b1565cc37e7a6" => :yosemite
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
