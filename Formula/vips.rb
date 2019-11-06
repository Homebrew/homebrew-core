class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.8.3/vips-8.8.3.tar.gz"
  sha256 "c5e4dd5a5c6a777c129037d19ca606769b3f1d405fcc9c8eeda906a61491f790"
  revision 1

  bottle do
    sha256 "153d701602b9bbc3e967b06fbfa9975c7e80cd61b0416ac722b3e75ef4a6dcbc" => :catalina
    sha256 "bc2a573f9a144ec6298d3dbb281af0cc79102fb6acf2255cd1eb5e56749da4d1" => :mojave
    sha256 "d019e48e4a7573fb6727618e01817658ce242fabab1eb394b02b70316b6b5205" => :high_sierra
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
