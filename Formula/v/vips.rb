class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.14.4/vips-8.14.4.tar.xz"
  sha256 "f6b7d86f6f25528859bd191c7e1159a4d6d0bdc0f46197ae8109f2f9d3cb90c0"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "675eb4e196d427cebe67b42bfd5900e000f69def02892fb24165be24daaf2376"
    sha256 arm64_monterey: "5a38ccd25f5189e6e2bbdca3a23519ffe45fd0aefc43b3d87d45705e69f6acba"
    sha256 arm64_big_sur:  "cc1e2389531f4ad6b2b579589032102e8f5fa6cb1e05058fe473cf0febf586d0"
    sha256 ventura:        "7739777547142a5eb2cb594ba83fa7141343a84108d8a70dad07cbac16cee779"
    sha256 monterey:       "dc379c2c3cca5a41abe211182ba99bbec0d70fdf7c381cd20662959e1dd82922"
    sha256 big_sur:        "6c27001b21fdffe5a717fbcb4cd83c408bd51ae48bc13ba6d65318741c8561b6"
    sha256 x86_64_linux:   "23945857fdcea28e245511ab3bdad45b522402034bdb20e08744483ceb78dd05"
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
