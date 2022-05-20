class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 1
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "71d3c197d1c706920397b27c0405fac954605d1d1dde1231c7766b87ecbc2f77"
    sha256 cellar: :any,                 arm64_big_sur:  "c728b8e81b144f4dcf64b4b7396ebc4c8aa09cbf75d14d1f3f62bf47bf9267f8"
    sha256 cellar: :any,                 monterey:       "dbca500e47b00874c551b7b634fab01282f5e851bd661603559db0d39a4823bf"
    sha256 cellar: :any,                 big_sur:        "7506df75eb203cc4e9a9e63c7f930521e7a2f1cf7b9b8729c89cdeb0330b1d0d"
    sha256 cellar: :any,                 catalina:       "7083f680325f0a3a5838655239e143e95538828566c2d2af40bfcd938f160e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a3fac0f3a0002b329e6e841c5528f19fad2aacbc67964ed8e3f8b28e0f9667"
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
