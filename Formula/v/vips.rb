class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.18.7/vips-8.18.7.tar.xz"
  sha256 "5baaead3b0bb20ffdb9e9ff09aa9fda08620923df77b63b436654cb5e0b3bf94"
  license "LGPL-2.1-or-later"
  revision 2
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "5dd73c1e19542dd64f17b7d32b8eebe885e8aca818392962ea352608655ac8e4"
    sha256 arm64_golden_gate: "3ab6b72606d73d84988d178d4d2068fd7fc335f2bbd69255d1d020d5b4e0eb79"
    sha256 arm64_tahoe:       "84953cacf9f680e4b117d56877af9eb970af31d362647a4e0b86af472572f229"
    sha256 arm64_sequoia:     "3c51bcc9c013629477af326b92c798e3cf5e06cf85e68ebd2a5f2b19fa4b7200"
    sha256 arm64_linux:       "7a2167ac06ef48bd94b851b67869882f34947a9de7b2e4721895770b2e549c0b"
    sha256 x86_64_linux:      "e4c9b088442dd71d535760adad08b8fcd0d6a247cd7a80fdcc8b24ae01a270d4"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "cgif"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "glib"
  depends_on "highway"
  depends_on "imagemagick"
  depends_on "jpeg-xl"
  depends_on "libarchive"
  depends_on "libexif"
  depends_on "libheif"
  depends_on "libimagequant"
  depends_on "libmatio"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "libultrahdr"
  depends_on "little-cms2"
  depends_on "mozjpeg"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openslide"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  uses_from_macos "python" => :build
  uses_from_macos "expat"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # mozjpeg needs to appear before libjpeg, otherwise it's not used
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("mozjpeg")/"pkgconfig"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp

    # --trellis-quant requires mozjpeg, vips warns if it's not present
    cmd = "#{bin}/vips jpegsave #{test_fixtures("test.png")} #{testpath}/test.jpg --trellis-quant 2>&1"
    assert_empty shell_output(cmd)

    # [palette] requires libimagequant, vips warns if it's not present
    cmd = "#{bin}/vips copy #{test_fixtures("test.png")} #{testpath}/test.png[palette] 2>&1"
    assert_empty shell_output(cmd)
  end
end
