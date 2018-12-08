class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.7.2/vips-8.7.2.tar.gz"
  sha256 "66c8d1f1db1d0934091e101abe8b3de552f45fb03d120dc10aa15450058d4baa"

  bottle do
    sha256 "da18d5cf5f5df9e8de4a2c966aedb4eedb4825d3d1bf3530562785cf21c5c95e" => :mojave
    sha256 "9e21aeca8abe4b046ce62773a43ed780a992ce4d470d91f72e17be2eb56845ea" => :high_sierra
    sha256 "6b4fbc2e8cdd56844c63d4b2b1c9fe7817ee7e33aebffb946cf487aa972f2045" => :sierra
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
