class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.39.0/qpid-proton-0.39.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.39.0/qpid-proton-0.39.0.tar.gz"
  sha256 "41f3a8d910ba96dda79f405a35e943465d9869cd075346650c7d6c0dc33a6459"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "953b06e1664db1037f65d82d0225879391cd01c08075ee17a4c2528aa5f854c2"
    sha256 cellar: :any,                 arm64_monterey: "8fcadc267d94328c330744a638bf0bd128e20aff069003ce4714c65499cd58ba"
    sha256 cellar: :any,                 arm64_big_sur:  "f52d8f54fe7c9c33f39cdb98f87a72dcda803f17656185f69c7c6233fe55cf86"
    sha256 cellar: :any,                 ventura:        "996a21749cdb9788fde89fe32c4164cbb99d7049a91f1c40622f0df0d5d6898e"
    sha256 cellar: :any,                 monterey:       "9a42451725bfb6be00b161d7d494578c20ad00bb426986295ec4b5908b3eb326"
    sha256 cellar: :any,                 big_sur:        "19b7eef40cd1ff2ca3faf9b74d70190e235f9f30e7670902c64082be58f3a55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d091954fae7eb26140850f961f258634fda03eab4273d0fcc06905aa2f2f708"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
