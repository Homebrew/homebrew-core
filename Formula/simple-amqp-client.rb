class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  head "https://github.com/alanxz/SimpleAmqpClient.git"

  bottle do
    cellar :any
    sha256 "f2dd44e2182fa7da6d5e9dcc255ad06138b09be9e0619ecd07135e6fc2c35405" => :big_sur
    sha256 "97ceed4ae134cb5f01dc3c5efdafaccf3374aee7c748217eba9bb8624edb74dc" => :catalina
    sha256 "42bf1dcae157dc5e3ad6c274cfff63e0599d1c1fa2ed634696a26ec499e6b18f" => :mojave
    sha256 "0df2d53228ce5b30d670a67b36b8440158d4773c55c206456fc2762c7e820cec" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "rabbitmq-c"

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <SimpleAmqpClient/SimpleAmqpClient.h>
      #include <string>
      int main() {
        const std::string expected = "test body";
        AmqpClient::BasicMessage::ptr_t msg = AmqpClient::BasicMessage::Create(expected);

        if(msg->Body() != expected) return 1;

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lSimpleAmqpClient", "-o", "test"
    system "./test"
  end
end
