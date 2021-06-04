class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.34.0/qpid-proton-0.34.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.34.0/qpid-proton-0.34.0.tar.gz"
  sha256 "850c7dfc916610d211e746931c60f89879d21c7f710cf006e864a62ebf8b28e3"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1e1eb1a676e8b7319e885f465d9e68691aa1d6d53fd24c5c3c5968485370bb05"
    sha256 cellar: :any, big_sur:       "fc234cc28503eb3a4cac958459d93e133b54bbb40c92e78e8ba40f80fb33e33f"
    sha256 cellar: :any, catalina:      "1124dbec5ee262056277c368d201812a2aa5b2597f3175d7610180f58020cb80"
    sha256 cellar: :any, mojave:        "5fc09481d98d452afb04633def8de93ab7bf7c45e93b77f4a0b403ba3ce8d6c4"
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
