class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.5.0.tar.gz"
  sha256 "ba7d6bfb2ac0fc31d5c98bf103f180e3ed3dd9a5902de533fd94417e15c577a6"
  license "MIT"
  head "https://github.com/alanxz/SimpleAmqpClient.git"

  bottle do
    cellar :any
    sha256 "b828d93b62004e7433395e301b49c34684fbc1c04be449b644fac2c48383059d" => :catalina
    sha256 "e1db52f944e4ef3ae5dea668bab5d867998b2a6ef12b0c23efdf6b436a18e293" => :mojave
    sha256 "38a2c4ce935b19f60a81a1e396b8a00b034612ad76f35b1de0d327afe12cc07e" => :high_sierra
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
