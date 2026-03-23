class Xkbcomp < Formula
  desc "XKB keyboard description compiler"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/app/xkbcomp-1.5.0.tar.xz"
  sha256 "2ac31f26600776db6d9cd79b3fcd272263faebac7eb85fb2f33c7141b8486060"
  license all_of: ["HPND", "MIT-open-group"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94c2d20aea0e61fc141e27bbe54fbf3ccf925c96fd9feea8f7bd6635a320cee3"
    sha256 cellar: :any,                 arm64_sequoia: "26572a4aac52f2bfa4042a9d1437b43e458a1e6cef25c7a324bed606d814057e"
    sha256 cellar: :any,                 arm64_sonoma:  "4fa4e7a20f893a19f9b4b9a5d8d75618690a2e62b850819e2ea00a866dd69f65"
    sha256 cellar: :any,                 sonoma:        "279212c9fcc8a124cd34fe55a8dc18242bd31e94f3baf634f9c066906433f632"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f81ffd52c4f1e2c651340725196bbb20d7ee9546b5de721273207f64591d5a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa59cc3f15db3ac79bf395bea5937f57957e611da69a05bad79214a19560440a"
  end

  depends_on "pkgconf" => :build

  depends_on "libx11"
  depends_on "libxkbfile"

  def install
    system "./configure", "--with-xkb-config-root=#{HOMEBREW_PREFIX}/share/X11/xkb", *std_configure_args
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
    assert_path_exists testpath/"test.xkm"
  end
end
