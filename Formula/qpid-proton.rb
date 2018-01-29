class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.20.0/qpid-proton-0.20.0.tar.gz"
  sha256 "b7d6e61b428b04a483068d0cc7cd2b360034a86897549bff5a2124eaac1cc38a"
  head "git://git.apache.org/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "9979c6172efb6204940c8e5c3db56327e5f4bdbfdba813ccc22e58b63a76ad9c" => :high_sierra
    sha256 "c2e974445169d038df19540141aa92eb843aca2ee50ec0114f25762830e7ef34" => :sierra
    sha256 "d0f5100b839fd2e7f122194c091f27af206a664eadffa81234056cdd68494f0c" => :el_capitan
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
