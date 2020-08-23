class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.31.0/qpid-proton-0.31.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.31.0/qpid-proton-0.31.0.tar.gz"
  sha256 "9ae3845188afd5988fed7e640a493c21fa02d3e77d26d39c013abfd937aedcea"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "0a141799096c2d617e2a2c37a2878289b910b3519d1b1c67ad5f89f9258465fc" => :catalina
    sha256 "95cdc65b975386aeea18453d2459a74482d21af14f78d1258f70214b233c6dbc" => :mojave
    sha256 "04c42fdd07d1e9e489b7e42ac552aa48ddb0fc98fb71a71e4795dbfa348a3c2e" => :high_sierra
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
