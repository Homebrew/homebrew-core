class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.14.4/vips-8.14.4.tar.xz"
  sha256 "f6b7d86f6f25528859bd191c7e1159a4d6d0bdc0f46197ae8109f2f9d3cb90c0"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "65a1f48e077ca9830369db635e6800f8a18e58ed0ff21f2c4e0f570d2595174c"
    sha256 arm64_monterey: "7e05c76b0795c97f4af740de151da4a6cd2c469a2f43be019e02ba59907bf745"
    sha256 arm64_big_sur:  "54812f2b710835b84f7d6cfebd83ce4198ee519ab1833bf87ac8951452666b2a"
    sha256 ventura:        "a0471a195de3a6ddc3101b500286273ce2fec4c3bef31c509543560098e9b4d2"
    sha256 monterey:       "fd555decb7d5c8ac108c94665fcd7891ad1ac2d4183e49443451ac701adc369d"
    sha256 big_sur:        "cbdf08eee6bd1717570ee671161389692985510c5c2b72c22c370c4ad149c24b"
    sha256 x86_64_linux:   "3ddcc8c8558b1b672fa18e6c0da8448af235a2a3021d1646b367d6d6b13f6539"
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
