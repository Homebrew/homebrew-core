class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.37.0/qpid-proton-0.37.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.37.0/qpid-proton-0.37.0.tar.gz"
  sha256 "265a76896bf6ede91aa5e3da3d9c26f5392a2d74f5f047318f3e79cbd348021e"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "57f4664016b0cded28149675e1fa668ac2b32f1918402f9cbf2e02ccc635ea3d"
    sha256 cellar: :any,                 arm64_big_sur:  "0ba5caf1d2f3a0ebf4148c6c323570dd800cfd8dafc14dc972dab9f3201673de"
    sha256 cellar: :any,                 monterey:       "cff783e83560e3a08e52092a5b9a8cf7de2d48a14d6b36b5f323acf4f5af3f06"
    sha256 cellar: :any,                 big_sur:        "72a8f436d43b2ee9f9fddead48d21990a6dd3e95afb4d5691a55d3e3f0db52a7"
    sha256 cellar: :any,                 catalina:       "0d29e0f4749b5196e520ed34dcf3a78bece3a2f74f0c18ecf2b04fba93eff9c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4ecc72758ad5ecca0643fc40f24e6ed8ce5f54215812f2296d816d849411e6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_BINDINGS=",
                    "-DLIB_INSTALL_DIR=#{lib}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-Dproactor=libuv",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
