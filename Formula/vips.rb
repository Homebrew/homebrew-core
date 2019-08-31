class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.8.2/vips-8.8.2.tar.gz"
  sha256 "aba3f97d60c344c5d40ffcec524460e378dab939f873ec5d155bbc510a4fbd5d"

  bottle do
    sha256 "0d4c5fe25f0baf4d94bc8f84e846514aa73a310dd63d591eeeda509c3a83b287" => :mojave
    sha256 "1d5ddbaf2899261128844630dbdd70e99a9e5f491d836a38b00588b016bdb378" => :high_sierra
    sha256 "80dce1b45641295a092cedf88b4a7c122dee42bcbde810ecc1a24ed18edad96f" => :sierra
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
