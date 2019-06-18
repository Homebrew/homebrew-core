class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.8.0/vips-8.8.0.tar.gz"
  sha256 "8e78b451adfe59288bded74c9ec6b8c5eb0574ecbba7a0352de4f34266e021b0"
  revision 1

  bottle do
    sha256 "75e6bd18a991e1623f45c5a878f9a570e47a099af1c5f1cd14c0d9ac94cfccdd" => :mojave
    sha256 "bbc0e3fbdfce90115bb1548f99f34cda0ba1cbeca8d152254466f69a35d5aa3c" => :high_sierra
    sha256 "bf4018db4352ab35b76b73a6cff297f452eeea543675d433202b3f208f1adf87" => :sierra
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
