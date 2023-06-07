class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.14.2/vips-8.14.2.tar.xz"
  sha256 "27dad021f0835a5ab14e541d02abd41e4c3bd012d2196438df5a9e754984f7ce"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "834ecc709b7bbc6b355c333c8bc04b4cad503f1276e832a1d3f2f178ed7c7670"
    sha256 arm64_monterey: "73a5076121e80c058be25ee27aad981a74d642dc301261559b51d432e56eb97b"
    sha256 arm64_big_sur:  "e83f8d00ed9cb9a5561b6e7e76693d0e36d20830f30411970fa51f78e438e0b2"
    sha256 ventura:        "986c3dd78113f49bfa03794218e46805cf31907c8ad181c50c3189acc81fa9ce"
    sha256 monterey:       "9f5f29390c5e040dd154a690dce38689958db456d7bff5a7b0d1962196ca7945"
    sha256 big_sur:        "28ec6abf206a66a1186791044780218264b00131f9ab725a96b96e49f7505ee2"
    sha256 x86_64_linux:   "0b377b7181b90a843893aea0295e625ac5a4f97488109b98d27b391b052d1dad"
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
