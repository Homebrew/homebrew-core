class SblimSfcc < Formula
  desc "Project to enhance the manageability of GNU/Linux system"
  homepage "https://sourceforge.net/projects/sblim/"
  url "https://downloads.sourceforge.net/project/sblim/sblim-sfcc/sblim-sfcc-2.2.8.tar.bz2"
  sha256 "1b8f187583bc6c6b0a63aae0165ca37892a2a3bd4bb0682cd76b56268b42c3d6"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/sblim-sfcc[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9b75fdfd7494479190a2651966a17408dfa29a1f2f62c860e165caa5f135a6df"
    sha256 cellar: :any, big_sur:       "8a334b1f1c440e4103ab947b0871ea160a0d319cf095e8ce8b45521ec9440770"
    sha256 cellar: :any, catalina:      "d20839c77aaa1c968981ca9af0e92bf1c7f600392ea5674971f532040dae518a"
    sha256 cellar: :any, mojave:        "ff61a006626a9a36dafb474f352d798805b1a44adba341d8422bd0820eaae1ab"
    sha256 cellar: :any, high_sierra:   "0ee558ce892d6e04acfe7ca2408a96e2837c7c858e71f6047b3a57a15b75ece0"
    sha256 cellar: :any, sierra:        "2e1eea4bbad906293b2c48a27a09fd76d665ab0c9259ef49fcd81f4783fbb67c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cimc/cimc.h>
      int main()
      {
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcimcclient", "-o", "test"
    system "./test"
  end
end
