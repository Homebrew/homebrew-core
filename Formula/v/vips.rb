class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.17.3/vips-8.17.3.tar.xz"
  sha256 "41e9a1439cd57dcc6d4435a085e2cfe181d9da1962fa84a484f09e8b536e4b77"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "4f44cc392df532999605e02234097ac91042184f8d5f3a6c8a414225e7260845"
    sha256 arm64_sequoia: "456f9d782dd6b2af4d8311b8d040988abf8af69fd89400c1ebc085b4c29f9733"
    sha256 arm64_sonoma:  "67e7abf054152ee0163f3761f8f6308d7250b148dd863c3700aed2fb6e4d3217"
    sha256 sonoma:        "42bef575db06850228f3c4cb09895c43c4c02164aca9c83fa32f9584c7ab792f"
    sha256 arm64_linux:   "5c412ee24f00dfca055cfb8df678d728ba5a0ece5a98d785f8997674368a23bd"
    sha256 x86_64_linux:  "9bdc27bcffe24ac1397fd84fb6a9b40a65656e7ee3776a40abdf8a556749ec00"
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
