class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.22.0/qpid-proton-0.22.0.tar.gz"
  sha256 "518769fa0857a425c3dfe9f581fc5fb5675aa37ebe19ca17624929eae5226bdc"
  head "https://git.apache.org/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "431c6f65b931704fc9d7d290d2967d1770deeaa1be6a2c74ce0834dcc4a1ca91" => :high_sierra
    sha256 "6433d72fa657ae84e09924647aa52363e609ea2c09f3c2261970e7da41300afa" => :sierra
    sha256 "dff2f3b4820a51c01631262772bbbc5e67946099de0cd5fcc1776711f0cae936" => :el_capitan
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
