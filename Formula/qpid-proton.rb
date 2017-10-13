class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library."
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.18.0/qpid-proton-0.18.0.tar.gz"
  sha256 "7f54c3555a8482d439759c087d656d881369252af23f209f1fd5a7e4a8c59bd7"

  head do
    url "git://git.apache.org/qpid-proton.git"
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl"

  def install
    # Do not build language bindings and enforce installation into lib/ instead of lib64/
    args = std_cmake_args + ["-DBUILD_BINDINGS=", "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=#{lib}"]

    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "proton-c/CMakeLists.txt",
        "CHECK_SYMBOL_EXISTS(clock_gettime \"time.h\" CLOCK_GETTIME_IN_LIBC)",
        "CHECK_SYMBOL_EXISTS(undefined_gibberish \"time.h\" CLOCK_GETTIME_IN_LIBC)"
    end

    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl"].opt_prefix

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lqpid-proton", "-o", "test"
    system "./test"
  end
end
