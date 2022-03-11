class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.36.0/qpid-proton-0.36.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.36.0/qpid-proton-0.36.0.tar.gz"
  sha256 "d2a6bf00265a07ba526983b07604534c7c7b564923254565b42d1f97274e92d8"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "9bdd11b59d7053bfc72caead2ccd1ef42e5f1d89af5cc0c2eba8a00d51aefc98"
    sha256 cellar: :any,                 arm64_big_sur:  "39ea3802c036cb9910545438cb7c764b1da6f7c84c5629d2c027ed090f481651"
    sha256 cellar: :any,                 monterey:       "bd86d22429ab0cdff9af75a3fd15991be3971c5e7f9f4b6b87e5ee3098daada2"
    sha256 cellar: :any,                 big_sur:        "0f481b524222ee75d8e87aaba0ff177ba16a4922b4107d611214c9b1cf6c0bb9"
    sha256 cellar: :any,                 catalina:       "53aadbabf40bd674b7af81f7bcd865211cce7a460fb134d26995fcfa5eb5457b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d39167d95ae392568b1eb79616b5d48506c18b413a6ab49b5402f2dc577077"
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
