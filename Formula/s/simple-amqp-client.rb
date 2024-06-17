class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 8
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "645346f36e74f61005db4ad163c83fb2b3934a0de1377b472926ab68b1b35c85"
    sha256 cellar: :any,                 arm64_ventura:  "625eb8a2de9b7c42a7a0ac8c83d5595769a68ed085dd9aac75f0dc577b2cb67f"
    sha256 cellar: :any,                 arm64_monterey: "3cdd0fa3e91338c63c2eae38a5216f31f35ee7149f58b8a5fd6e658ed07ec715"
    sha256 cellar: :any,                 sonoma:         "f42f3b677edeaa0ff889d55e4cf864d3f5628de8fac90c3fb9f0948c521ce75e"
    sha256 cellar: :any,                 ventura:        "bfa2411426319a0b3c2c8749e5ad8ea655e4a86daa6d966c21d363c3a96b5f4f"
    sha256 cellar: :any,                 monterey:       "4b758c02d215e4d0812344c10c2a0c03c362843628623e0b5c86c0715c34edb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38cf99fc2c567e1c68c42325fd229b686677c43d450ee2e197a1f0814edf0075"
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
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lSimpleAmqpClient", "-o", "test"
    system "./test"
  end
end
