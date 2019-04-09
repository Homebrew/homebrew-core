class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.7.4/vips-8.7.4.tar.gz"
  sha256 "ce7518a8f31b1d29a09b3d7c88e9852a5a2dcb3ee1501524ab477e433383f205"
  revision 1

  bottle do
    sha256 "b79a1dd2a31c66ccaef76c1a80b45fed626070892170fb6b2d17fc77aae2169d" => :mojave
    sha256 "5b0e853a2df0f58a23fc050727293b4c8a3157b6d162f5d42b1c83d0d26da21c" => :high_sierra
    sha256 "4d3c4c02757bad0508029fb491331fb8a5217af2852e4a52811ed911326e8438" => :sierra
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
