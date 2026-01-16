class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 13
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d412b6de7b7131e3940c3cb6c6de590851da8475fc52214d7e5a7bc4e23630b7"
    sha256 cellar: :any,                 arm64_sequoia: "34336c39998749444352e2928d0737d6de1e1130ec584592edb8ad89cfd468bc"
    sha256 cellar: :any,                 arm64_sonoma:  "6cf87592a1de61ad79ef81efec558a08bb229c68cd0b090d24e92bc49ca6edfe"
    sha256 cellar: :any,                 sonoma:        "9b14b52e4aba5528038d4afcfafaa8dbc45244efdaf2e6615664db56d510d6c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9361f043d1ae8d104f0e27504b7fbaf262501bcdcdc189b0dde6d7dcfd278f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "816871d1c73e83de194d29a0c89f41e62b8beb6e873c7a30736b878e93ee6273"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "rabbitmq-c"

  # Fix build with Boost 1.89.0, pr ref: https://github.com/alanxz/SimpleAmqpClient/pull/356
  patch do
    url "https://github.com/alanxz/SimpleAmqpClient/commit/3d3c669608b0dc3ae54e9caae6244bdcc38ca054.patch?full_index=1"
    sha256 "652aad326ace036498e2f990f6fecaa9d2472e04885f581d773fb1fbf3809e9c"
  end

  def install
    # Remove hard-coded CMAKE_CXX_STANDARD
    # Else setting DCMAKE_CXX_STANDARD does not work
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 98)", ""

    system "cmake", "-S", ".", "-B", "build",
           "-DCMAKE_INSTALL_LIBDIR=lib",
           "-DCMAKE_CXX_STANDARD=14",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
