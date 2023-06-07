class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org/"
  url "https://downloads.xiph.org/releases/speex/speex-1.2.1.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/speex/speex-1.2.1.tar.gz"
  sha256 "4b44d4f2b38a370a2d98a78329fefc56a0cf93d1c1be70029217baae6628feea"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/speex/?C=M&O=D"
    regex(/href=.*?speex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e8e8cbefa65f7819b2feb27b9067248d97f2e5607253c0a5c8a49a495d7fc824"
    sha256 cellar: :any,                 arm64_monterey: "b0cba69db1b66944a019f312fa128d6c6460f971fdd5cfddc0725051b76a4dd0"
    sha256 cellar: :any,                 arm64_big_sur:  "3cb6ffa6920e1ea4e904bb0e2a8d6e62c329c39c6f7d80d8c66f691b5ad1f427"
    sha256 cellar: :any,                 ventura:        "ec27dfb9443b9de3ca68ca3239ab655aa33078f7345bd33a07aa1ba05987538c"
    sha256 cellar: :any,                 monterey:       "46d02ec9d80e46fbf260fe650abaa3f4620743ca34a59d53d55d382894231a41"
    sha256 cellar: :any,                 big_sur:        "45e58f000c17211a9624b247cf58d85ea6a191f8c5bfe0efaf6ba72b49a63fc1"
    sha256 cellar: :any,                 catalina:       "21a5518f517dabbb9eb1d80d14e0e7716fd36f7db01e779b875b733db4c5fa14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea2ee48a402525421cb3ef8b83173d4bc57741c10e84fe6fae66691905293ec"
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
