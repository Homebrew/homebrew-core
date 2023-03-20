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
    sha256 arm64_ventura:  "723f63554af72e8afe72639fd19fa0972b3045e87b76d239974457e97441236f"
    sha256 arm64_monterey: "99316e36756f6130aeb45e8a54f876d9f58f02ce3efd82fa7bfb11b52a3c3e36"
    sha256 arm64_big_sur:  "e8685da9f9fa3ad204e99e7c86cfcffadb270cfd0671bc3f0ff250001da06a0c"
    sha256 ventura:        "3efbc36e88e380c09af5366a6e4dfa47460aa4a4e6cba138b8dd419f995884e5"
    sha256 monterey:       "4aaab9204a4457ca2a4d7a9ba8be23df077c57707f91baaa325240506bad46c7"
    sha256 big_sur:        "036232ab9c3bae1ab8d29a7a61ecf128d3221d62b19b66fd5eed0bbef403bb5f"
    sha256 x86_64_linux:   "236dbc8946fb9088c709309c6ec382cc107dbb29c682f7ceaf5d4534ab4eb8dc"
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
