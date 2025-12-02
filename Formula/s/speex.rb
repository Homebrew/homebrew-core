class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/speex/speex-1.2.1.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/xiph/releases/speex/speex-1.2.1.tar.gz"
  sha256 "4b44d4f2b38a370a2d98a78329fefc56a0cf93d1c1be70029217baae6628feea"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/speex/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)speex[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a7608ef62c92fd11d5eed0e3643e769087e4f0eb6de3a321fa602d6dd041387d"
    sha256 cellar: :any,                 arm64_sequoia:  "885ccb79dee4ad080d2c5ee20ab55569b0dfee064535a537568dd78adff88dcb"
    sha256 cellar: :any,                 arm64_sonoma:   "8dcf1981467ac7b19763ef294c2ef1cbb5fdbe98100043c95f4617a89a930a22"
    sha256 cellar: :any,                 arm64_ventura:  "e8e8cbefa65f7819b2feb27b9067248d97f2e5607253c0a5c8a49a495d7fc824"
    sha256 cellar: :any,                 arm64_monterey: "b0cba69db1b66944a019f312fa128d6c6460f971fdd5cfddc0725051b76a4dd0"
    sha256 cellar: :any,                 arm64_big_sur:  "3cb6ffa6920e1ea4e904bb0e2a8d6e62c329c39c6f7d80d8c66f691b5ad1f427"
    sha256 cellar: :any,                 sonoma:         "7dec70341e9b992efda633567a11bd75ce9bc9a21ab3490a2a37800cf0a0fc55"
    sha256 cellar: :any,                 ventura:        "ec27dfb9443b9de3ca68ca3239ab655aa33078f7345bd33a07aa1ba05987538c"
    sha256 cellar: :any,                 monterey:       "46d02ec9d80e46fbf260fe650abaa3f4620743ca34a59d53d55d382894231a41"
    sha256 cellar: :any,                 big_sur:        "45e58f000c17211a9624b247cf58d85ea6a191f8c5bfe0efaf6ba72b49a63fc1"
    sha256 cellar: :any,                 catalina:       "21a5518f517dabbb9eb1d80d14e0e7716fd36f7db01e779b875b733db4c5fa14"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a2e8649afd3a104cc1e685c4047bf6e44d9229f226981c86cb558bb512818da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea2ee48a402525421cb3ef8b83173d4bc57741c10e84fe6fae66691905293ec"
  end

  head do
    url "https://gitlab.xiph.org/xiph/speex.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libogg"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lspeex", "-o", "test"
    system "./test"
  end
end
