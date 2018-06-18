class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.23.0/qpid-proton-0.23.0.tar.gz"
  sha256 "b7af9e5e36526a0a6d1a6dcad1e5fe76cc868f2fd7f5bb9c3bd0bba00031e23a"
  head "https://git.apache.org/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "341448cc48c2f4a8c9ff9005d61b48d611659123cd6a7618e39cdbf38d764c0e" => :high_sierra
    sha256 "afd39f9dd615383e17031e174948b8c5f517c04f8bf847dbb5222ebe78adbafa" => :sierra
    sha256 "37af5bbca107162afafd6537ff0aece23fb0cb4f42df5dfa417647b11c544b8b" => :el_capitan
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
