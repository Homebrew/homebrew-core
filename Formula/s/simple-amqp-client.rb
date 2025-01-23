class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 10
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "113b5ded452952e6ece8e1ac1f36abbe862bac2e36dc6933ccf85277d92d423a"
    sha256 cellar: :any,                 arm64_sonoma:  "bb232a7dd23e721fab644f9853f8daece9d4ade01397d823ecb7e5765f002d9c"
    sha256 cellar: :any,                 arm64_ventura: "701415d086b41bc3d4d81f2b9f2455b62e4d4ced88429aedefac7c366133347d"
    sha256 cellar: :any,                 sonoma:        "dac31186f89a2cb1aa4b20c0c3e5b2f7d61cca70b8469a0501e976a8f6bc4783"
    sha256 cellar: :any,                 ventura:       "c037064915eac9fbe507101aba085e58c7b5cd86e3dffa2b4f0f374bb232ab50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2abfcf884b581f32544e4873d8285e27080f95814eb9513e54ed54b44fc17c24"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "rabbitmq-c"

  def install
    # Remove hard-coded CMAKE_CXX_STANDARD
    # Else setting DCMAKE_CXX_STANDARD does not work
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 98)", ""

    mkdir "build" do
      system "cmake",
             "..",
             "-DCMAKE_INSTALL_LIBDIR=lib",
             "-DCMAKE_CXX_STANDARD=14",
             *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <SimpleAmqpClient/SimpleAmqpClient.h>
      #include <string>
      int main() {
        const std::string expected = "test body";
        AmqpClient::BasicMessage::ptr_t msg = AmqpClient::BasicMessage::Create(expected);

        if(msg->Body() != expected) return 1;

        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lSimpleAmqpClient", "-o", "test"
    system "./test"
  end
end
