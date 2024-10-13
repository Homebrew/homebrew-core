class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.15.3/vips-8.15.3.tar.xz"
  sha256 "3e27d9f536eafad64013958fe9e8a1964c90b564c731d49db7c1a1c11b1052a0"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "fce13d6f9209ebad7ab6a1cf811031f4b0fe08b862d5eb57a2603c385f344068"
    sha256 arm64_sonoma:  "a4e9481a8a8ccdfec359e9d1dd0cc4be2c7b808637cfbb478038c8b9a1bff743"
    sha256 arm64_ventura: "c6f4321e5b9df29dd879841a82580bdd1a7111e186cf3520368b25a054c432c3"
    sha256 sonoma:        "e8964412f1f0d5120e5e3dfc2b7e15d5fc15ab0f4f3d29b0e3a3754c44556c6f"
    sha256 ventura:       "e13f252b4dd0fddbad75a34b052740229116401ca198ac097a81c62023d5c211"
    sha256 x86_64_linux:  "2dc0a6e4aaf9021bd6c0403731b9c73df973f792fbccada27755a167705af88a"
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
    system bin/"vips", "-l"
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
