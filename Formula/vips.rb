class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.13.3/vips-8.13.3.tar.gz"
  sha256 "4eff5cdc8dbe1a05a926290a99014e20ba386f5dcca38d9774bef61413435d4c"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "e5e6a2647f2fceec5b3051ea2429729dd20047e722a7e744af067e88aac3299c"
    sha256 arm64_monterey: "c761a33f0ff6f4a55c5f5cd1638877eedfb3902ef557de1ada16623f4bcbd831"
    sha256 arm64_big_sur:  "68b41f4aa00a0816609eb04429c432e7a31dfe02591605ceeaf8559907d6de68"
    sha256 ventura:        "457eeb8cf5289a0e58f45517c80f4fed10e61d1a94f354fcac8161c104cea956"
    sha256 monterey:       "9f92448977e4da88f4bb07abe47abb29fd0140cda3b86790d31851a236ffb4b4"
    sha256 big_sur:        "0258071ddc03ee0ca22060e07c725268443a41ece340117ba98ee13f82cb5eeb"
    sha256 catalina:       "e0ca4d500634b2bddb534a0b3c9915133b69bc7a3a4bc7a326fe171afff88204"
    sha256 x86_64_linux:   "90a3587e1691d2de2320901a428301f05e2c768120cea3a93e1df5e476faf57d"
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
