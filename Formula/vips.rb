class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.6.3/vips-8.6.3.tar.gz"
  sha256 "f85adbb9f5f0f66b34a40fd2d2e60d52f6e992831f54af706db446f582e10992"
  revision 3

  bottle do
    sha256 "583dacfe5fdd5336d869e57b30ff24e4b9d262d56cf0bda598c35a2adda8648a" => :high_sierra
    sha256 "522fef56658dfbd46dfa1d892a7d5598a057859fe554438082fa08b73ad1376e" => :sierra
    sha256 "8dd32a6dd00e2d3f056c4c5547e088a52a3908926f448d7dca03ab40f7a05626" => :el_capitan
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
      --enable-pyvips8
      PYTHON=#{Formula["python"].opt_bin}/python3
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
