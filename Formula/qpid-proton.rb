class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.36.0/qpid-proton-0.36.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.36.0/qpid-proton-0.36.0.tar.gz"
  sha256 "d2a6bf00265a07ba526983b07604534c7c7b564923254565b42d1f97274e92d8"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "987a082ca3bd1ff2ea46cf92abad14a4281fef6c3741e4e0598890b739c26180"
    sha256 cellar: :any, arm64_big_sur:  "c930656951faa99f5d58f6dcedc055232f1f3d59af4e6ff0248b574892b70652"
    sha256 cellar: :any, monterey:       "88afcae9366a99216e04102dd95d596c94085849695457077c90bc91c3f48078"
    sha256 cellar: :any, big_sur:        "383385b7dee17c6be66dcfa3d951cc20336b6eae4bdc0f37ee48684da64a9892"
    sha256 cellar: :any, catalina:       "ff5753223dc4f1374dd5e5773c560b5f7e75d0e8cee724ea4b08387649adcf5e"
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
