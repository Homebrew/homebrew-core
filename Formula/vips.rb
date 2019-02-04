class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.7.4/vips-8.7.4.tar.gz"
  sha256 "ce7518a8f31b1d29a09b3d7c88e9852a5a2dcb3ee1501524ab477e433383f205"
  revision 1

  bottle do
    sha256 "b0f5e9de2c412d6f188fe36371d7c828c735f8b873bc68d9058a0d6145751476" => :mojave
    sha256 "9813262b061a45991e1e4b1e8a6d4100ef29f8af5d23cae37911e2cdfff81433" => :high_sierra
    sha256 "56a18f3f056bd18584574e244c487b0d8e48756a86453e8f9de9e4d16fdd10a2" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "imagemagick"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "openslide"
  depends_on "orc"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-magick
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp
  end
end
