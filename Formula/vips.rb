class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.8.1/vips-8.8.1.tar.gz"
  sha256 "a0ee255a2a1ebfea5b2dff2a780824d7157a78c010d7ddd531279aacefbf2539"
  revision 1

  bottle do
    sha256 "90736385728be69c24fbb99e2ac5904212ab622af3c2cf53d833cab7233a86c3" => :mojave
    sha256 "c8d6223e1e7037b7bef79863d0657fd1e5806fa7b8b46377d58d5534563020a3" => :high_sierra
    sha256 "a12f3dc4cdfbbdaaf78da50a1401816b1fac610bf9421e7e6cae84a7004cfced" => :sierra
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
