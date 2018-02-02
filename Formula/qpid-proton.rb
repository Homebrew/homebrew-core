class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.20.0/qpid-proton-0.20.0.tar.gz"
  sha256 "b7d6e61b428b04a483068d0cc7cd2b360034a86897549bff5a2124eaac1cc38a"
  head "git://git.apache.org/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "07eced3f64068e9560817eabd189d208e38ab6ea44ef4098085be81ae2e3bdf1" => :high_sierra
    sha256 "c347c628dbceabb09865dc06f525d655bfd2aa3eea7ee827de8e82636ba8daed" => :sierra
    sha256 "57e79c5c3320e85b290a535b8c36c9044ffe7925adf00242864593ff7cea8a99" => :el_capitan
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
