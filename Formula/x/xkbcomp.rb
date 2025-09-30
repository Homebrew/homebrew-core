class Xkbcomp < Formula
  desc "XKB keyboard description compiler"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/app/xkbcomp-1.4.7.tar.xz"
  sha256 "0a288114e5f44e31987042c79aecff1ffad53a8154b8ec971c24a69a80f81f77"
  license all_of: ["HPND", "MIT-open-group"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3eed6169b9426b62dffe9623dfa9d1664f3efe9013bae806fb1cac758ac83f14"
    sha256 cellar: :any,                 arm64_sequoia:  "a0b770e6a7ef934ac5b4fc86d683013e9ec4b1813852884b27362129357ffc57"
    sha256 cellar: :any,                 arm64_sonoma:   "21f807d7ff040f4f919aa8b785e84589013a24e492618fb2f68867a20b83ff85"
    sha256 cellar: :any,                 arm64_ventura:  "fac529997c4a64e907d0bbfa31c5d7b4223bcb978f139de89a5a57d904280279"
    sha256 cellar: :any,                 arm64_monterey: "8005d7a24f88589b10d4b305668a0daf00c3262096cf2824b33b9ee2b820cb57"
    sha256 cellar: :any,                 sonoma:         "748bc8b2b4367a4a2a429939d866cad1d3f2c39827d817dcc8005677decfdec4"
    sha256 cellar: :any,                 ventura:        "64d4dd5de94b681390d9488addba6c89d1d2cfdc64fc84d3daa7c308868bf3d7"
    sha256 cellar: :any,                 monterey:       "4bf88bfe3df2a85e6a4e16cb61b92f7a1e91b4e7b1f526014912fc789de34205"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e96e612b7dabac0251953af322c5045f238c702df84100378d3ebc6e0d4ec6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6be95ca9ca5cb1c2afaa4e0d2cf31d75f5daa5e543a824c3c9cb9f6d895c25e2"
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
