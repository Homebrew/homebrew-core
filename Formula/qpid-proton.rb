class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.35.0/qpid-proton-0.35.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.35.0/qpid-proton-0.35.0.tar.gz"
  sha256 "a2d21cd9612dd79332ca18b794e372256e9b8eb12195cd8ffcb69043e32b5926"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5771a4a81c0ddaae9e6c8f1620c59c250d96af2eab7891989afa56117d2458d0"
    sha256 cellar: :any, big_sur:       "7a3a7e1b0e3345e8a818790d1998f0cd23e8b35a4dfeec7e7ba351bd1074949d"
    sha256 cellar: :any, catalina:      "7a5eb027bc0c1a91fbadc053db6a6aec8d2bda10026fe9e77b0bdbee072e9cdd"
    sha256 cellar: :any, mojave:        "e14be728833288e29ac4b153e1b99d398a9ea0cdef1aef7665dc62c358892ea9"
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_BINDINGS=",
                         "-DLIB_INSTALL_DIR=#{lib}",
                         "-DBUILD_TESTING=OFF",
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
