class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 5
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "08254107e1722e12718b480db1dbf6de07197827921a78becfe322d0f9eebe68"
    sha256 cellar: :any,                 arm64_monterey: "8b276e2dcd1d156db170e63af4b947ce370e87c511808810ae1a8dbd3c7c74b4"
    sha256 cellar: :any,                 arm64_big_sur:  "6eb50b2ded72ece524376758aad62fcfa41001e07f7c118800494d23302b968e"
    sha256 cellar: :any,                 ventura:        "96b8108c180fa64cac43b882cec0bb675b4e029170beeb60b034cc137f7cfe3f"
    sha256 cellar: :any,                 monterey:       "0266a55c8bc15714604fd6ed646a6e3e4254cf3204db8044b12c2a8b93f50be4"
    sha256 cellar: :any,                 big_sur:        "e453369d97ecbe31463b1bb86f4b9ab9c0bb1082f0c9f44eb1e15f5700fbc642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dddcb4edfe7fb23b493c2ccb330b7a68c802d8996ee34170c6f529341f919aa"
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
