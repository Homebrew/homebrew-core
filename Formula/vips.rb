class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.8.3/vips-8.8.3.tar.gz"
  sha256 "c5e4dd5a5c6a777c129037d19ca606769b3f1d405fcc9c8eeda906a61491f790"
  revision 2

  bottle do
    sha256 "8c31d6738b85b66511af4c73ffb3cfe5ea28c795fa953a55498f717722f69b81" => :catalina
    sha256 "e47f5605d1838c9d7733bacda4fe0b6755e94a8431b9fd190d37a669997d9e08" => :mojave
    sha256 "46df8329d0438446b0da1cf17fec608627c33bf3ad3d13abd597ecb955e75ec7" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "imagemagick"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libheif"
  depends_on "libmatio"
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
