class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 10
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cd6d4094aacae310f0c808a8192bafbb2ca569bca87e95bb4f2f53e6f21733f8"
    sha256 cellar: :any,                 arm64_sonoma:   "7eb2dfc39d39dc1d154e86e8de9eda347187128e5a79d3b5118ecdb7e51f8e5f"
    sha256 cellar: :any,                 arm64_ventura:  "d0f9c687e9acc3b0f837117973ce49d4496fa9028ef889fc31e7750c2a7b6405"
    sha256 cellar: :any,                 arm64_monterey: "eb540cf125e6d28a226b43a051f2459210aa3b13ea991618b004f2582c53b869"
    sha256 cellar: :any,                 sonoma:         "d2bb07617ff3af4cd6e7d5ef12f960e7370a6582e482abea1676a1de4b0bf2be"
    sha256 cellar: :any,                 ventura:        "680c8b48533c107811207e2d6cfdcf4a15747f4b17ec46d3f19dd6dd792bc71a"
    sha256 cellar: :any,                 monterey:       "c4c72635a60f7e5ba392384e3e100f64084d7c9ec73dbdea437d9badac5ecb4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b632ee61e266aab62c8a1418dff3e705ac8a5c01b78f26a76070307307d009b0"
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
