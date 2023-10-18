class Xkbcomp < Formula
  desc "XKB keyboard description compiler"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/app/xkbcomp-1.4.6.tar.xz"
  sha256 "fa50d611ef41e034487af7bd8d8c718df53dd18002f591cca16b0384afc58e98"
  license all_of: ["HPND", "MIT-open-group"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "79c49e5e0cf0b34e2406df87d5d859b956383f8c96438cce3667d4e3c6cbd634"
    sha256 cellar: :any,                 arm64_ventura:  "f8b766cdedfc9f611c2ca97b916f6e5d6880cfff6b6a990839c33cad8cb26ba9"
    sha256 cellar: :any,                 arm64_monterey: "89dc191e89a7775a9517539ec3e3b7aa309e084976d80ace8525b049b63ee9e5"
    sha256 cellar: :any,                 arm64_big_sur:  "bff3f733c2eaba11bb0f8f0ffbbd5767785beb4d6b0c852ce5c3ab37b8d6f515"
    sha256 cellar: :any,                 sonoma:         "db884f05b2526c504fbc336106539da87b4317503ae051041b70f8f93eda0bda"
    sha256 cellar: :any,                 ventura:        "6ca5ba3842a7f37e3b86a2cd1646b422c2c3b4f85e08500f16ee9304819d2c88"
    sha256 cellar: :any,                 monterey:       "21d1c0ce944cc6d65f7c497e79499b07c5a27d9fafcb301f2150fa7be32dc223"
    sha256 cellar: :any,                 big_sur:        "01c848065f03e59bc681d657f6e0aff3d5b0d6218498a69054b4b55aa391db37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad4064d27f8fee9aded27cef9436e3bd6497f8976f44a689c3838e31459f91cc"
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
