class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.16.0/vips-8.16.0.tar.xz"
  sha256 "6eca46c6ba5fac86224fd69007741012b0ea1f9aa1fcb9256b0cbc2faf768563"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "3b90ba29d5d55d92ba0edd25b8090b8ee32bb3445c4ba80ef18a1639d1d68d1e"
    sha256 arm64_sonoma:  "e532c9d87946242e7f5aa2478232521020a64887187a070d8da7ad5d9a7f1852"
    sha256 arm64_ventura: "8b3455bdcd2487585a1af0e4aec46f1aab504fbffffc5a7c381666bbb1e17b11"
    sha256 sonoma:        "210f56748403e9ae47a8972322272c8718c0a4baabfc38ce1e021b5d29187bf9"
    sha256 ventura:       "9e8f38efa15c093fb2b861ec7696d0b8a244b30ce1a1a327fedff5bffe707034"
    sha256 x86_64_linux:  "faa60367d98711a92e578569cb34323946fe6a40cdb258a6aaa41b39fe8314dd"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "cgif"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "glib"
  depends_on "highway"
  depends_on "imagemagick"
  depends_on "jpeg-xl"
  depends_on "libarchive"
  depends_on "libexif"
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
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  uses_from_macos "python" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    # mozjpeg needs to appear before libjpeg, otherwise it's not used
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["mozjpeg"].opt_lib/"pkgconfig"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    if OS.mac?
      # `pkg-config --libs vips` includes libarchive, but that package is
      # keg-only so it needs to look for the pkgconfig file in libarchive's opt
      # path.
      libarchive = Formula["libarchive"].opt_prefix
      inreplace [lib/"pkgconfig/vips.pc", lib/"pkgconfig/vips-cpp.pc"] do |s|
        s.gsub!(/^Requires\.private:(.*)\blibarchive\b(.*?)(,.*)?$/,
                "Requires.private:\\1#{libarchive}/lib/pkgconfig/libarchive.pc\\3")
      end
    end
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

    # Make sure `pkg-config` can parse `vips.pc` and `vips-cpp.pc` after the `inreplace`.
    system "pkgconf", "--print-errors", "vips"
    system "pkgconf", "--print-errors", "vips-cpp"
  end
end
