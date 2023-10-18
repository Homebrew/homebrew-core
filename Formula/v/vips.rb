class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.14.5/vips-8.14.5.tar.xz"
  sha256 "90374e9f6fbd5657b5faf306cacda20658d6144d385316b59b865bc1a487b68d"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "2cbe1d771809811fa56a2acb028fb0820785795fc794af9b1b72e66b44f4f3fd"
    sha256 arm64_ventura:  "c97a9b9780926184cf907c97b0ed7e554e25c038d72b3af8ba5d6cc12b064e78"
    sha256 arm64_monterey: "00463fb1bd0925f36c8059e9f9754da0983388f07289f3b50ad6eacf128dc49a"
    sha256 sonoma:         "4308408e413d3ac7296d7d8a0d0fdae068a2395cc49c6e2c161aba1d573223f2"
    sha256 ventura:        "7986a5899d22a0fa29ad780261ca9f5284e36cf5ecdfbfa153f66ccd3592bb86"
    sha256 monterey:       "91aeaa35b6e30fc59943d1ffa25719724dd458a5b31533cdfc5919372e90e5fd"
    sha256 x86_64_linux:   "7139751abe3b9991dfde262b24cda79dc424874d9c6b0f7512b34a8a753a88c5"
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
