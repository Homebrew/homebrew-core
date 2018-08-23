class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.24.0/qpid-proton-0.24.0.tar.gz"
  sha256 "384aba2561388f1fa592809a058f5cc93579beab398721182d58df6469b1ae25"
  head "https://git.apache.org/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "832fd7db6ac604c47d66b35d4171eb26d523b7916ac10345da3355477cc191e5" => :mojave
    sha256 "c6f6a73a0277433a7241ffd8f13de0a7ddf2b6a7e894169026db2dbdf1665c66" => :high_sierra
    sha256 "70f55ed22438eb4beec799b70723f104eb9bb9e53988b54e2b0bf69c344991b3" => :sierra
    sha256 "f73b3ecdfcdc3743181e7daae8e0f4fb00a47a07e1960a3836c9d70c71bf7499" => :el_capitan
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
