class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.29.0/qpid-proton-0.29.0.tar.gz"
  sha256 "7dfee950e40f3bd89edf1b1d41874fe129ba25ea3068300aa2578ddc67680bef"
  revision 1
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "0b3f1c52f2a0c02531a0a86cdb41a31d1d641309fa8f5de551b6e6b5922cc971" => :mojave
    sha256 "0844cba721198292397a460bafdcc7362b2553c1bd13b9176e5397dff8ea17ba" => :high_sierra
    sha256 "51e8e477136a8c92363adb25f5f8fd2aa244a2b4f493874a94e380279e75ddf8" => :sierra
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
