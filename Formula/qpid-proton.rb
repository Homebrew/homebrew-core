class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.33.0/qpid-proton-0.33.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.33.0/qpid-proton-0.33.0.tar.gz"
  sha256 "cb532c12b1bedb8d811398d46d5d9c0fd9d011553e5643c125b0366738bbf1b0"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "f36d96b5b1c8312c04b6ee484db491f9aefc05c0dbed095a3e429bc8d9ad8915" => :big_sur
    sha256 "04bed9699fa8e399d7361dd79e2819780e43cc5a9d3d1d221f1085a644801e09" => :catalina
    sha256 "a6fb688d4b98625e77f1886284ab795374dcba771504301c4114825e79084ef0" => :mojave
    sha256 "754da3603d6c444bd392dcc94b28a1d8da76489dbf972638644889278b75932f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_BINDINGS=",
                         "-DLIB_INSTALL_DIR=#{lib}",
                         "-Dproactor=libuv",
                         *std_cmake_args
      system "make", "install"
    end
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
