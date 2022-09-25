class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.13.1/vips-8.13.1.tar.gz"
  sha256 "ad377b7e561bb2118de9a3864fcaa60c61ba7f47e849f6044d1b339906197702"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "d80754b65c0cebadfec262509bdb1d3ba612ac4d2816b58de4930b4adacb36c2"
    sha256 arm64_big_sur:  "813ca47272e8d3b88c2d30d5c190137aa2b525fbae626ea459a043f6fb18e023"
    sha256 monterey:       "4c5882f10591209eb3337c6f6f1a96b7c4a214dd5f64b2470ada7280259ee951"
    sha256 big_sur:        "eae9f30e6d1a22e41472facf37f78a9a285bd003ab0dce5a02aa9a91bc1f0f14"
    sha256 catalina:       "bb36f709353d7f7128dbec7b4f500bd12fb87e174dc149e191a1c31067a593e8"
    sha256 x86_64_linux:   "a246cde2f92677386854e7249e644c26f7af4a9f70ab2fa8806cf205377d77a0"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "cgif"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "glib"
  depends_on "imagemagick"
  depends_on "jpeg-xl"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libheif"
  depends_on "libimagequant"
  depends_on "libmatio"
  depends_on "librsvg"
  depends_on "libspng"
  depends_on "libtiff"
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

  fails_with gcc: "5"

  def install
    # mozjpeg needs to appear before libjpeg, otherwise it's not used
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["mozjpeg"].opt_lib/"pkgconfig"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
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
