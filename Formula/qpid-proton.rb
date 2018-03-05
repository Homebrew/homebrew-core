class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.21.0/qpid-proton-0.21.0.tar.gz"
  sha256 "40df0588abb44ef89fc72979e54d3cab66b0dcafd17838df19b1b0897ffa515c"
  head "https://git.apache.org/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "9a45195d3d192da54ccb33d73902e58cf3e9f57739c0a1535b875aa306655089" => :high_sierra
    sha256 "8c3750d6fbeac81d8acc112e17255a9efbe1c1ff7596fd26a728759050484504" => :sierra
    sha256 "cea841ab6de9415bd0d0b763fc7b621b3f16af7491a3878a611433dee645249a" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl"

  def install
    system "cmake", ".", "-DBUILD_BINDINGS=",
                         "-DLIB_INSTALL_DIR=#{lib}",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "proton/message.h"
      #include "proton/messenger.h"
      int main()
      {
          pn_message_t * message;
          pn_messenger_t * messenger;
          pn_data_t * body;
          message = pn_message();
          messenger = pn_messenger(NULL);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lqpid-proton", "-o", "test"
    system "./test"
  end
end
