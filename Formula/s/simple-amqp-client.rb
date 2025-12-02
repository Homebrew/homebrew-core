class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 12
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "31777723001b1b546f4650740d5f44b36e77ea2792ef44acd6988cc3911622ec"
    sha256 cellar: :any,                 arm64_sequoia: "e1eb5c48884a83b02dbbc2a0ad3d8d356f7c3fb935f8fc54341ae756bb4424e5"
    sha256 cellar: :any,                 arm64_sonoma:  "eb19eaee74b987a22007c12f737a270bcc32913ba5cb822331c4d34b7cea09f3"
    sha256 cellar: :any,                 arm64_ventura: "f5b70aba922a61a69ebeb2378e955fbf27bc5b15cf9e6f1ec608286b65d6410a"
    sha256 cellar: :any,                 sonoma:        "b53ed9cf4ac06bce440b6cb5b128e408d60d8a8394db5c9b09247b974ac2c0c2"
    sha256 cellar: :any,                 ventura:       "2eeb8c8ac5f48881dc6c88e402d0bb2528975e66cbe59ba8a64286d9df6b1d07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dacbc3f04fe93b070000d9469fa1b192ad7567339abd577a7798d03877ee487c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dae899a11bd849dc1d61c0b9099ccc7b188392a4cbb607ac57c91b3585250f09"
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
