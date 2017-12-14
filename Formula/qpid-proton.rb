class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.18.0/qpid-proton-0.18.0.tar.gz"
  sha256 "7f54c3555a8482d439759c087d656d881369252af23f209f1fd5a7e4a8c59bd7"
  head "git://git.apache.org/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "01cb4331c91536a040141f1066d4c8fb214736a0653916e15313ce689af7661a" => :high_sierra
    sha256 "86a8ae2a3c173ca3ec44898f3dde3b60b44b089f22bc18a7070295cd27d8a1b9" => :sierra
    sha256 "55974792bec574a06943581f22ad4f5861947fd0ea936b742a053f2695a98692" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl"

  def install
    system "cmake", ".", "-DBUILD_BINDINGS=",
                         "-DLIB_INSTALL_DIR=#{lib}",
                         *std_cmake_args
    system "make", "install"
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
