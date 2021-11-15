class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org/"
  url "https://downloads.xiph.org/releases/speex/speex-1.2.0.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/speex/speex-1.2.0.tar.gz"
  sha256 "eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/speex/?C=M&O=D"
    regex(/href=.*?speex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bf2e015b7ee410466636785326e8f3d83e4a9eac4c2f69d3305adc59867e01aa"
    sha256 cellar: :any,                 arm64_big_sur:  "6fa6fadc24bf645344850be769b61adcefffa425c7cc456e127d35a4bb1b7b17"
    sha256 cellar: :any,                 monterey:       "abdca3b468964ebe04b09b0f357770cef53d3b2946b78eae169a5d39466aa011"
    sha256 cellar: :any,                 big_sur:        "4eab5b7d16f9a249b65156765cfdf1fca13d59f9bdd599c266f075f740b0ff81"
    sha256 cellar: :any,                 catalina:       "0f83411cb7338f92a588672d127c902e0b45d1f7276befa2206bc870208d5bb0"
    sha256 cellar: :any,                 mojave:         "ed212ec09c4a1a2c789e5c2a7a2679b56c75bcf252a52fe28d6615499d21534f"
    sha256 cellar: :any,                 high_sierra:    "525970161e7c1629b242c91d889201ca368814945695efd5b441d58b5b5dcc75"
    sha256 cellar: :any,                 sierra:         "5aa61761fb5426de78297fdc83579515dda1a880f47c925cb3405b7175079b92"
    sha256 cellar: :any,                 el_capitan:     "056781a4d7c5fe9a05f30160c059352bda0a4f8a759820df7dde7233aa08cba5"
    sha256 cellar: :any,                 yosemite:       "a0b3c91782b8242508adac3ebc0cd86688e75b043ea0d84f4ef7ac9940f8a21b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9a94a31b5c192244224fa11d3e48fe5e0f68e0b597edf82f2b2b99b14e80e0a"
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"

  def install
    ENV.deparallelize
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <speex/speex.h>

      int main()
      {
          SpeexBits bits;
          void *enc_state;

          speex_bits_init(&bits);
          enc_state = speex_encoder_init(&speex_nb_mode);

          speex_bits_destroy(&bits);
          speex_encoder_destroy(enc_state);

          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lspeex", "-o", "test"
    system "./test"
  end
end
