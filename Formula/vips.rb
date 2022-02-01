class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.12.2/vips-8.12.2.tar.gz"
  sha256 "565252992aff2c7cd10c866c7a58cd57bc536e03924bde29ae0f0cb9e074010b"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "20d671529252314b17c8f3eb4be159543c864c96c429cb68cbe8a7bcf85770ac"
    sha256 arm64_big_sur:  "f125f9b4ff5157974ff9d0b72397e2bdb1a8dae0c89a7f5d4e22ed725437840a"
    sha256 monterey:       "8f6f1c98bba10185571a371349d73dbaab6ea91aa776c318b280037cf6371375"
    sha256 big_sur:        "0d42d2f1ce288913155cf7cb7ae74882c6929f7613d8f89bc6da370c55c3661b"
    sha256 catalina:       "17daae6e1c77856c58df8278eee46bc72c89ef8f6172979817930d842ed51875"
    sha256 x86_64_linux:   "33d5a6b70eed88db1973afea1121b771df265a1853054bf7c0a96f828e1e3bae"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "cgif"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "hdf5"
  depends_on "imagemagick"
  depends_on "imath"
  depends_on "jpeg-xl"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libheif"
  depends_on "libimagequant"
  depends_on "libmatio"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libspng"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "little-cms2"
  depends_on "mozjpeg"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openslide"
  depends_on "orc"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
    depends_on "gobject-introspection"
  end

  fails_with gcc: "5"

  def install
    # mozjpeg needs to appear before libjpeg, otherwise it's not used
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["mozjpeg"].opt_lib/"pkgconfig"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
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
