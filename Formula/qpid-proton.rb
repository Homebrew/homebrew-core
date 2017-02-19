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
    # Perl, Python, Ruby bindings switched off - leads to linking errors
    cmake_args = %w[
      -DBUILD_JAVASCRIPT=OFF
      -DBUILD_PYTHON=OFF
      -DBUILD_PERL=OFF
      -DBUILD_RUBY=OFF
    ]

    # qpid-proton require build in a subdirectory
    Dir.mkdir("build")
    Dir.chdir("build")

    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl"].opt_prefix

    system "cmake", "..", *cmake_args, *std_cmake_args
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}64", "-lqpid-proton", "-o", "test"
    system "./test"
  end
end
