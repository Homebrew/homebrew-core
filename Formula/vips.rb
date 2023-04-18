class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.14.2/vips-8.14.2.tar.xz"
  sha256 "27dad021f0835a5ab14e541d02abd41e4c3bd012d2196438df5a9e754984f7ce"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "99dc528b41302ef8ffa559ae5a72883527d858aa3aefd2f33821a1315bebfb70"
    sha256 arm64_monterey: "1a6adb34a18fbeabb3c123b7558c98912e8a8acd858b49fbe355579974d8222c"
    sha256 arm64_big_sur:  "39a82d82a990e586053c9998214784f7789d4d1ecdd11afe80cc88926079e857"
    sha256 ventura:        "d7171662e1cc327c6f5378a3549f01c017e8d0f8b06ad790bb0277fe49940d7c"
    sha256 monterey:       "83ce4bc7e2d890431536b7a872653a08bc34bf13c88f9415d4c6feecfaaa93b4"
    sha256 big_sur:        "b2c5915d1158b6345e7ccc3a5046a9a89248ca569682abaf870ebc455f7f6862"
    sha256 x86_64_linux:   "5ae4e539fafb769c06f1ac544fb9300c3e264539fd194ecc332c9ac6881089e4"
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
