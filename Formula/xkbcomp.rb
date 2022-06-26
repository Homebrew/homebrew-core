class Xkbcomp < Formula
  desc "XKB keyboard description compiler"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/app/xkbcomp-1.4.5.tar.bz2"
  sha256 "6851086c4244b6fd0cc562880d8ff193fb2bbf1e141c73632e10731b31d4b05e"
  license all_of: ["HPND", "MIT-open-group"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "da94cb771debb09217e45550470e2299982cd7a01ecb648d3ea0ddd940c80f04"
    sha256 cellar: :any,                 arm64_big_sur:  "c2007073201bb91ad1fa13fb49aef7ef2a89c2eec3d5812f98414eeb7c2198b7"
    sha256 cellar: :any,                 monterey:       "2c78f64a5b041ae4c98d993a9640802b55c4424292c5fe22effc5df6a7668b80"
    sha256 cellar: :any,                 big_sur:        "0890c9c6ba0c4eaedb5d5d241a751af3f40d45a4f8fa5c3487c2674fb0db02b8"
    sha256 cellar: :any,                 catalina:       "9836909cc79f81d13fbe2f4a361f07d9013f16ab6ddcab8ebced35ebdf158790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "503bab67d583ae0ad8ae02b5e1bced7c6db9804ff57aad88eca351e83ec230e3"
  end

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
