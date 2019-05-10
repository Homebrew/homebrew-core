class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.8.0/vips-8.8.0.tar.gz"
  sha256 "8e78b451adfe59288bded74c9ec6b8c5eb0574ecbba7a0352de4f34266e021b0"
  revision 1

  bottle do
    sha256 "cf4409d66e6006768d4f44ac4b84949c1eb514379e6a2f9504ec80f3907e37cc" => :mojave
    sha256 "4efc956661bffbb3e3cfab387fff034beb5d13b412f900d8fb6dd17410988fa7" => :high_sierra
    sha256 "f05f3262a88ec63f1a609fe22f1001431620601437c64822d41e68b617f23141" => :sierra
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
