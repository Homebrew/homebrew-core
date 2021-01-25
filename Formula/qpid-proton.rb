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
    sha256 "8fbc4f2dd6d3da1b582d4ac681efbe6642556f5ac32f15ee9fc1519ffd2d00bd" => :big_sur
    sha256 "95e0eee7ab97b025c67e28d3463eb903216820361a39e247683814a75c4f6ba7" => :catalina
    sha256 "2322808f69519175c64b268a7ea75dceab4c3a8d3d898d4637a3dff066d2f69b" => :mojave
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
