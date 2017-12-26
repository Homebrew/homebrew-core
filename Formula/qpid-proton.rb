class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.19.0/qpid-proton-0.19.0.tar.gz"
  sha256 "33187252f9f31200cb97df5eb19bf0a1935370184094a4dd19231a6638606451"
  head "git://git.apache.org/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "daf4c3a3836be78f84d8bfba99e6b4132530bc6bb56a890fb39e5e5a87a656e9" => :high_sierra
    sha256 "6275c32cb870cf632f100159a48bb55240534ed9bf39cc2ff04b26cb596de268" => :sierra
    sha256 "b5af79dd305bd3473586e32fdbaf03b752d6d5dffd681c7d785a0a8dacc4c281" => :el_capitan
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
