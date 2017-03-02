class QpidProton < Formula
  desc "is a high-performance, lightweight AMQP 1.0 messaging library."
  homepage "https://qpid.apache.org/proton/"
  url "https://www-eu.apache.org/dist/qpid/proton/0.17.0/qpid-proton-0.17.0.tar.gz"
  sha256 "6ffd26d3d0e495bfdb5d9fefc5349954e6105ea18cc4bb191161d27742c5a01a"

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl"
  depends_on "perl" if Formula["perl"].installed?
  depends_on "python" if Formula["python"].installed?

  def install
    # Javascript bindings switched off - leads to build errors
    args = %w[
      -DBUILD_JAVASCRIPT=OFF
    ]

    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "proton-c/CMakeLists.txt",
        "CHECK_SYMBOL_EXISTS(clock_gettime \"time.h\" CLOCK_GETTIME_IN_LIBC)",
        "CHECK_SYMBOL_EXISTS(undefined_gibberish \"time.h\" CLOCK_GETTIME_IN_LIBC)"
    end

    inreplace "proton-c/bindings/perl/CMakeLists.txt",
        "RENAME cproton_perl.so",
        "RENAME cproton_perl.bundle"

    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl"].opt_prefix

    # Enforce installation into lib/ instead of lib64/
    system "sed", "-i.orig", "1s/^/set(LIB_SUFFIX \"\") /", "CMakeLists.txt"

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
      The modules for the perl and python bindings can be found in
        #{Formula["qpid-proton"].opt_prefix}/lib/proton/bindings
    EOS
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
