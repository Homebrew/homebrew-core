class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.7.4/vips-8.7.4.tar.gz"
  sha256 "ce7518a8f31b1d29a09b3d7c88e9852a5a2dcb3ee1501524ab477e433383f205"
  revision 2

  bottle do
    sha256 "692e5f23a3aa7d99cee8c703781e7f2857fa35586677576dd487d3c7ef37b2ca" => :mojave
    sha256 "e44d8afef77da76bc6aede109bdc28b378c72ba8f04505e7b675330760bce30b" => :high_sierra
    sha256 "9c56b78629089148a227a81816dfed7b94bbd2d4a016ea5c5bfbd50dde52ab10" => :sierra
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
