class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.14.5/vips-8.14.5.tar.xz"
  sha256 "90374e9f6fbd5657b5faf306cacda20658d6144d385316b59b865bc1a487b68d"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "9f1d7309268ed8f6ecc1cadcfc39cd3e7ba1275b3417d429ab79ad141b529b91"
    sha256 arm64_monterey: "098f6ab0a43ae8700d56ffe204fdbfe47469178830e60257cec66f9d45910933"
    sha256 arm64_big_sur:  "6ed403aa32c9685527cba0c08f9e2e5e40688e3009eea578911ef1a23bcbf65d"
    sha256 ventura:        "4cf77fb01d2eadd23de82cb9aa5c2c3bee891c8f4388df4b19beb4ab9bbbe6ff"
    sha256 monterey:       "abb6aca9d89e67f1c0c056dd107a7ff6096f70c624884875d14ef18ea87f94a8"
    sha256 big_sur:        "590174408c0ab938d9267bb00508ff32a94d7f00b58246b990ddf05131b99702"
    sha256 x86_64_linux:   "5de34dbdbc901c84783f0613ce97d584d288bfb2d9bcc7aba13681292b0501e4"
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
