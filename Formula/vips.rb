class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.7.0/vips-8.7.0.tar.gz"
  sha256 "c4473ea3fd90654a39076f896828fc67c9c9800d77ba643ea58454f31a340898"
  revision 1

  bottle do
    sha256 "a72995a85a9aafb3621512e130ac9dd92eafeacc766def2464d53b9a9ead2c0b" => :mojave
    sha256 "9ee9fe7ea6fe4221fdcfbc03af393dc001fe791c26b0e2237bae1dc0d08c584d" => :high_sierra
    sha256 "5523f0cd90a60871db6ce36329c6f0d6227e2ce33e20f2e548db074cdbe9f69e" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "orc"
  depends_on "pango"
  depends_on "webp"
  depends_on "fftw" => :recommended
  depends_on "graphicsmagick" => :recommended
  depends_on "poppler" => :recommended
  depends_on "imagemagick" => :optional
  depends_on "openexr" => :optional
  depends_on "openslide" => :optional

  if build.with?("graphicsmagick") && build.with?("imagemagick")
    odie "vips: --with-imagemagick requires --without-graphicsmagick"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "graphicsmagick"
      args << "--with-magick" << "--with-magickpackage=GraphicsMagick"
    elsif build.with? "imagemagick"
      args << "--with-magick"
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
