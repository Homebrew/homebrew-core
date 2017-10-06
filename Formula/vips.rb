class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.5.8/vips-8.5.8.tar.gz"
  sha256 "07a3b8966a816a834dd60dc1745ae1930f3bbe604e826986a5a2bbd7f45c5426"
  revision 2

  bottle do
    sha256 "d0a7f0efe6f9ae89706d11b4541f0234dcb2767310c5d3ca225bb32175d5d8bd" => :high_sierra
    sha256 "89fdabb07d18ac3cf22448e1bbb6f862a383763faa6a254083cb8ce10c9b0811" => :sierra
    sha256 "325e7eff92545311553e8ba100b70e7b8b2eb9ff7b12a0c4573035f3e468e01a" => :el_capitan
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
