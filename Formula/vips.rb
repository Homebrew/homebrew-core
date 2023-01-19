class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.14.1/vips-8.14.1.tar.xz"
  sha256 "5abde2a61f99ced7be4c32ccb13a654256eb7a0f6f0520ab61cc11412a1233fa"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "5d9cf41a7b0b0ecae7239e70fabf436c13e033fd54d8815c06d07da93c82be78"
    sha256 arm64_monterey: "06362c448a4ccc075cecd40ae3a65b867a6069c5ebe10b146432c5a68771deaa"
    sha256 arm64_big_sur:  "0fc0bbf805212caa10d8d3e7c85ea57e6135f5200f77dac04fced55fcf350b2a"
    sha256 ventura:        "80a330062fbec27b987949e37b116aaac0a945aca23b47b28e90d86b1daf201f"
    sha256 monterey:       "a246803dd66e6adfe0371ab589136191ebfd5c4a783d3b3deae3d94283efc7b0"
    sha256 big_sur:        "84e7acb3ae6bf40e88b9beb687a84032835f73820b390458dc56b95a3ae96bfd"
    sha256 x86_64_linux:   "663b82d9b145ea81dd2a0947be99e8bf4a28aa7151b26790211f208f9485cc26"
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
