class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.30.0/qpid-proton-0.30.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.30.0/qpid-proton-0.30.0.tar.gz"
  sha256 "e37fd8fb13391c3996f927839969a8f66edf35612392d0611eeac6e39e48dd33"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "d469e523daa8394adaf7d45e877fc287914a33aa33164c89361a390b5e48b9ab" => :catalina
    sha256 "608f3141669345fe847bea58a150f6959cb9fd2d5f26c235540dda29d0aec779" => :mojave
    sha256 "3ba386ace69b0795b5e1b1dc65e9bd089564aea03d20bc98271cd559abe906ea" => :high_sierra
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
