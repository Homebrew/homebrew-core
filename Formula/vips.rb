class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.7.0/vips-8.7.0.tar.gz"
  sha256 "c4473ea3fd90654a39076f896828fc67c9c9800d77ba643ea58454f31a340898"
  revision 1

  bottle do
    sha256 "6f082f98d6c3e30f9c843146e02e9894862900226cb78644d82083beb62ebab6" => :mojave
    sha256 "9ad940df6592e4395833a035cf0b3b0efe0a1af80a1d581ed1fe705630b11887" => :high_sierra
    sha256 "cee84df2c6fc8cf4217e54f463bea8df1b20598c27732d78059b7dfdb4c0ba7c" => :sierra
    sha256 "071679f42687bcaedfd2ff398afd7e2bd96e66c8eb48ab5b1b00c7d96c97450f" => :el_capitan
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
