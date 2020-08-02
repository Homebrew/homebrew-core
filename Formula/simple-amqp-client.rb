class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.5.0.tar.gz"
  sha256 "ba7d6bfb2ac0fc31d5c98bf103f180e3ed3dd9a5902de533fd94417e15c577a6"
  license "MIT"
  head "https://github.com/alanxz/SimpleAmqpClient.git"

  bottle do
    cellar :any
    sha256 "3afc1f1345a391514200462825dcecf87bde3d25476d5f9bf87b787877c632c5" => :mojave
    sha256 "fa561d92f855cf6613343e33741ac715d3fb42fce6ac2adf1fbc00fc641434df" => :high_sierra
    sha256 "4f9fc0338fe628eaeb02c4cfb377a8f5e90da37896e6ec91968f30649069b129" => :sierra
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
