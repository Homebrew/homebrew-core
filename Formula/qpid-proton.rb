class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.33.0/qpid-proton-0.33.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.33.0/qpid-proton-0.33.0.tar.gz"
  sha256 "cb532c12b1bedb8d811398d46d5d9c0fd9d011553e5643c125b0366738bbf1b0"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "a24a18a5d17a1f4d221676d8fa7e7bfff6fdc598708d4b07010ffa2ecefdf5b0"
    sha256 cellar: :any, big_sur:       "37ac24b89b4a23abff75e11dda46d71403e39abc148906a2f77a65cf61f63804"
    sha256 cellar: :any, catalina:      "5bb29532d0ac3ea61cc1c58b2bf3975f76d9cb7ff8e53b7a692558279a7ddcaf"
    sha256 cellar: :any, mojave:        "9718338d5d938b7264df5a0312ff36a9060c5bd41c8b7bd439e6821238f10010"
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
