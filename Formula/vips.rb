class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.14.1/vips-8.14.1.tar.xz"
  sha256 "5abde2a61f99ced7be4c32ccb13a654256eb7a0f6f0520ab61cc11412a1233fa"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "89f9a62fd49fd39e0cbe5ce3b77c80a3f47a52575df5477aae60eb738d872c67"
    sha256 arm64_monterey: "29f1f4a7d3d927b191bb26defca28e4bad3344ea7afa3d33db7a5fbfca726f8f"
    sha256 arm64_big_sur:  "2884df86d18b3898d342ca8f922af616b62c497ad36bfcd452253a32107f58a8"
    sha256 ventura:        "1203702f732137074b8a9e5da9e3aeb0265855a6b195d4b73afc58dcadbf9f56"
    sha256 monterey:       "5b1c61579b54e1fad915053fd2a7e6f40b06416655eb8df6cebab2519c7ae205"
    sha256 big_sur:        "ca7c799f8dcad83ab7e95a3acef397b942f1393bc1363395557a698405a3234e"
    sha256 x86_64_linux:   "825958b211d74587f84a3b3652c8af15ca392c3cec0272ccc20c494ae3c7ae6c"
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
