class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.36.0/qpid-proton-0.36.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.36.0/qpid-proton-0.36.0.tar.gz"
  sha256 "d2a6bf00265a07ba526983b07604534c7c7b564923254565b42d1f97274e92d8"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "5afee190e5de08d145434f129bbc6d0fb152a6dd09ed074e4b0a52f8a1e96d4c"
    sha256 cellar: :any, arm64_big_sur:  "5771a4a81c0ddaae9e6c8f1620c59c250d96af2eab7891989afa56117d2458d0"
    sha256 cellar: :any, monterey:       "af60db5847bded1b78802125b5703ab47e38cb67b033749938d27b9c13d8bd6a"
    sha256 cellar: :any, big_sur:        "7a3a7e1b0e3345e8a818790d1998f0cd23e8b35a4dfeec7e7ba351bd1074949d"
    sha256 cellar: :any, catalina:       "7a5eb027bc0c1a91fbadc053db6a6aec8d2bda10026fe9e77b0bdbee072e9cdd"
    sha256 cellar: :any, mojave:         "e14be728833288e29ac4b153e1b99d398a9ea0cdef1aef7665dc62c358892ea9"
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
