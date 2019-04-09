class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.26.0/qpid-proton-0.26.0.tar.gz"
  sha256 "0eddac870f0085b9aeb0c9da333bd3f53fedb7c872164171a7cc06761ddbbd75"
  head "https://git.apache.org/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "3da4e0e50e5e8bd6fc6ce1cb8ce3373444746b100f4b9be12070c5835502ebdb" => :mojave
    sha256 "4892c0e802cb050bcc5eccda6dd94c9ac59a028672fe099dd2469eec702914ce" => :high_sierra
    sha256 "b5b4898b4902957ce8d0b36d9afadc766f1f134e0f1acfc771d57506f7c80e7d" => :sierra
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
