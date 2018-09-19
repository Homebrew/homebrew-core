class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.7.0/vips-8.7.0.tar.gz"
  sha256 "c4473ea3fd90654a39076f896828fc67c9c9800d77ba643ea58454f31a340898"

  bottle do
    sha256 "c7f36c1f4fd29836799ee740813dde1b89526b3b6bf5973a3326475b33c532f7" => :mojave
    sha256 "643ca879eecba97a5358eb43d0ae06e27b778bdaa85bc5023463850c6272c41a" => :high_sierra
    sha256 "c204bbafb4833dadc83c36d94f6e9e7eb4b130a8e56ce2676d8af31a0b4dbc5c" => :sierra
    sha256 "bc87fd01761821c50f1d9793250f04ef6a5c89635204ccbcb2d5874316db7a29" => :el_capitan
  end

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
