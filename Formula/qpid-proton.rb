class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.38.0/qpid-proton-0.38.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.38.0/qpid-proton-0.38.0.tar.gz"
  sha256 "ab8946e406e626ce0e9f0ed320bf8f0ecd30083ae2c07eec80f994addf1d46f6"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dab557c7eab733a2334ed7cda2a87c7fbca7cdb6a295d9352b53b22ff31c4caf"
    sha256 cellar: :any,                 arm64_monterey: "9bec8fe8349745cb8fdbee472fa64be6c1a6711423f89cb6e2bdae0e90dd10c6"
    sha256 cellar: :any,                 arm64_big_sur:  "a438ec0874c02dc1578d38fcc608c0a28fcfebf84e2451bfd6072c786407d148"
    sha256 cellar: :any,                 ventura:        "ea46f02d5f3b0588eebc03c72469dc150f3c3d29900ecd20c450b28300d28046"
    sha256 cellar: :any,                 monterey:       "247562ce7db9cc172094f9262ab30f423dfdd02be71594e7e2dc91853e83589e"
    sha256 cellar: :any,                 big_sur:        "0e4cc14c320a9d048763882c450c9c99546222d495ad93c21286edb358c3bf40"
    sha256 cellar: :any,                 catalina:       "f5b6ee0624a2acc2a408c7fc20a44bac0527962444a87b259250d0907f8aee32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb7aedbcc111dfaeb33fe1c095a49adc227ab5923c612ca067870a0a0ad29ee"
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
