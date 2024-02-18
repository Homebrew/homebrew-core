class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.15.1/vips-8.15.1.tar.xz"
  sha256 "06811f5aed3e7bc03e63d05537ff4b501de5283108c8ee79396c60601a00830c"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "a0749997ff5816cb91fde6245faefeeb779406a6e01eed5066dab7d0c04f78a8"
    sha256 arm64_ventura:  "14c821b0e22ed0ac696439ff56c107c559d19d9ae68ed18cbd63097ed5810e91"
    sha256 arm64_monterey: "e00796685e92788ed10bfc19ffdf60e6175be80c19e61229d97f3953fd55c2ee"
    sha256 sonoma:         "54758e656cb4d1ebd0e93315db4c180d2b66a937ceb979636b640f7f830f9ffa"
    sha256 ventura:        "4e0e2d7844dc730536652d3bad4e040aeab7a62e03c961191e30774da02222d7"
    sha256 monterey:       "e79c6b7c557a4b6e477680cd56055389fd233d1cd59a553314bbadaed5a56323"
    sha256 x86_64_linux:   "08fbcf6c9e2ed7348d1034080f4aac8b018a0f257e646aa6af7ce15e691929b0"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "cgif"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "glib"
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
  depends_on "orc"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  uses_from_macos "python" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  fails_with gcc: "5"

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
    system "#{bin}/vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp

    # --trellis-quant requires mozjpeg, vips warns if it's not present
    cmd = "#{bin}/vips jpegsave #{test_fixtures("test.png")} #{testpath}/test.jpg --trellis-quant 2>&1"
    assert_equal "", shell_output(cmd)

    # [palette] requires libimagequant, vips warns if it's not present
    cmd = "#{bin}/vips copy #{test_fixtures("test.png")} #{testpath}/test.png[palette] 2>&1"
    assert_equal "", shell_output(cmd)

    # Make sure `pkg-config` can parse `vips.pc` and `vips-cpp.pc` after the `inreplace`.
    system "pkg-config", "vips"
    system "pkg-config", "vips-cpp"
  end
end
