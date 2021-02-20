class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.10.5/vips-8.10.5.tar.gz"
  sha256 "a4eef2f5334ab6dbf133cd3c6d6394d5bdb3e76d5ea4d578b02e1bc3d9e1cfd8"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "7465e3684f04ad85463694971862aa3694ec67655b01e8d5d6eef6af22852af9"
    sha256 big_sur:       "423bdd4aa945fefc6dd01646892c429494620cc942a96f25e2eab72cc8088df0"
    sha256 catalina:      "8d60363727bb9f48e8733b8d570732734ae727809489547e8ec3c956a72569f2"
    sha256 mojave:        "49429e971e5550fd703dcdcd3647a0d14c08267fa7e5c2ac4f6e0a402e92fb2f"
  end

  depends_on "pkg-config" => :build
  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "imagemagick"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libheif"
  depends_on "libimagequant"
  depends_on "libmatio"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libspng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "mozjpeg"
  depends_on "openexr"
  depends_on "openslide"
  depends_on "orc"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gobject-introspection"
  end

  def install
    # mozjpeg needs to appear before libjpeg, otherwise it's not used
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["mozjpeg"].opt_lib/"pkgconfig"

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

    # --trellis-quant requires mozjpeg, vips warns if it's not present
    cmd = "#{bin}/vips jpegsave #{test_fixtures("test.png")} #{testpath}/test.jpg --trellis-quant 2>&1"
    assert_equal "", shell_output(cmd)

    # [palette] requires libimagequant, vips warns if it's not present
    cmd = "#{bin}/vips copy #{test_fixtures("test.png")} #{testpath}/test.png[palette] 2>&1"
    assert_equal "", shell_output(cmd)
  end
end
