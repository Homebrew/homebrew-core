class QpidProton < Formula
  desc "is a high-performance, lightweight AMQP 1.0 messaging library."
  homepage "https://qpid.apache.org/proton/"
  url "https://www-eu.apache.org/dist/qpid/proton/0.17.0/qpid-proton-0.17.0.tar.gz"
  sha256 "6ffd26d3d0e495bfdb5d9fefc5349954e6105ea18cc4bb191161d27742c5a01a"

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl"

  def install
    # Javascript bindings switched off - leads to build errors

    args = %w[
      -DBUILD_JAVASCRIPT=OFF
    ]

    if MacOS.version == "10.12" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      args << "-DCLOCK_GETTIME_IN_LIBC:INTERNAL=0"
    end

    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl"].opt_prefix

    # Enforce installation into lib/ instead of lib64/
    system "sed", "-i.orig", "1s/^/set(LIB_SUFFIX \"\") /", "CMakeLists.txt"

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "make", "install"
    end
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
