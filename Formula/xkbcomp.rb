class Xkbcomp < Formula
  desc "XKB keyboard description compiler"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/app/xkbcomp-1.4.5.tar.bz2"
  sha256 "6851086c4244b6fd0cc562880d8ff193fb2bbf1e141c73632e10731b31d4b05e"
  license all_of: ["HPND", "MIT-open-group"]

  depends_on "pkg-config" => :build

  depends_on "libx11"
  depends_on "libxkbfile"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
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
