class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.8.2/vips-8.8.2.tar.gz"
  sha256 "aba3f97d60c344c5d40ffcec524460e378dab939f873ec5d155bbc510a4fbd5d"

  bottle do
    sha256 "e6eac2ce68bbc05b07a9a6ba0752d7580a347214d482085b7524571206c40a4b" => :mojave
    sha256 "8134e306fa03e52461cb2a3c58c34cf07d2409d567a41e365b5a055f80cec994" => :high_sierra
    sha256 "fb34ec79044017e9e7af7fa0c9c77e6d89f715808cbbc8d41a8922e9eeb55ddf" => :sierra
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
