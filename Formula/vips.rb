class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.8.3/vips-8.8.3.tar.gz"
  sha256 "c5e4dd5a5c6a777c129037d19ca606769b3f1d405fcc9c8eeda906a61491f790"

  bottle do
    sha256 "2b2ef7ae88cfc411e860386a705a9580ac16b6ede3bdc058e77085e02f06e27b" => :catalina
    sha256 "7f823bc23484c3c00efc9dd3b6c2e152305639a66f6d9a39ae58c86fc123c1c3" => :mojave
    sha256 "107f0b0417f8676a829cf3c0923331d917696d6aed196f45f4de26823ed0be05" => :high_sierra
    sha256 "2d09af95e01b212b19dd00342ad2fb9ce8aa9956160a1a4dea7e7d7a860869ce" => :sierra
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
