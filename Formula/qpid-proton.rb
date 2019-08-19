class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.29.0/qpid-proton-0.29.0.tar.gz"
  sha256 "7dfee950e40f3bd89edf1b1d41874fe129ba25ea3068300aa2578ddc67680bef"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git"

  bottle do
    cellar :any
    sha256 "827a8566aa1d49c459e3939c94eee1777b55a9b9d02611fab466b2b21cac79df" => :mojave
    sha256 "66591e7a1ebe7fa672075a9d7be072570623dc10ee3e97c215dab562e1d708b5" => :high_sierra
    sha256 "9b35acbb95d42e5a282c3ed13a387998faa6bf0120e8c9bd0b538ef72ee4102a" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl"

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
