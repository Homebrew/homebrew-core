class Xkbcomp < Formula
  desc "XKB keyboard description compiler"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/app/xkbcomp-1.4.5.tar.bz2"
  sha256 "6851086c4244b6fd0cc562880d8ff193fb2bbf1e141c73632e10731b31d4b05e"
  license all_of: ["HPND", "MIT-open-group"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4a84896fed45058f5898811b2a9e0741abed6da8d13d43f251dd6a6820f17c67"
    sha256 cellar: :any,                 arm64_monterey: "e79078be650b291c1a4608b8db62c94e69a0ffc7471fc74ea5769ab93de284dc"
    sha256 cellar: :any,                 arm64_big_sur:  "32ee8ba2516d310be9f003dc991adf20d34bc4c3456451bee40405abd503c14b"
    sha256 cellar: :any,                 ventura:        "2930a6f19b64e8b6f9e6476f4ab89ffbbe3495e499cd9220cef0d95832511816"
    sha256 cellar: :any,                 monterey:       "727c2cb08d05bde6848a8cbbcab5749e2305422dc40b1e9464dac8f3838f2fdb"
    sha256 cellar: :any,                 big_sur:        "1753d5b515d66d0ffc26c28489e5d3de045780a1b5173e224916b16e66fd9438"
    sha256 cellar: :any,                 catalina:       "9149259223ec54b0b62302cf4290a954b8ca3bab31352f73ec59cc46401b7f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "750bfcb9ab5d92656277f0fe1810d0a41a5b6836f740e7cc83158e745838911b"
  end

  depends_on "pkg-config" => :build

  depends_on "libx11"
  depends_on "libxkbfile"

  def install
    system "./configure", *std_configure_args, "--with-xkb-config-root=#{HOMEBREW_PREFIX}/share/X11/xkb"
    system "make"
    system "make", "install"
    # avoid cellar in bindir
    inreplace lib/"pkgconfig/xkbcomp.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.xkb").write <<~EOS
      xkb_keymap {
        xkb_keycodes "empty+aliases(qwerty)" {
          minimum = 8;
          maximum = 255;
          virtual indicator 1 = "Caps Lock";
        };
        xkb_types "complete" {};
        xkb_symbols "unknown" {};
        xkb_compatibility "complete" {};
      };
    EOS

    system bin/"xkbcomp", "./test.xkb"
    assert_predicate testpath/"test.xkm", :exist?
  end
end
