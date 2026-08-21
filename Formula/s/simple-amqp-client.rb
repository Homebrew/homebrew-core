class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  license "MIT"
  revision 14
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  stable do
    url "https://github.com/alanxz/SimpleAmqpClient/archive/refs/tags/v2.5.1.tar.gz"
    sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"

    # Allow overriding hard-coded CMAKE_CXX_STANDARD
    patch do
      url "https://github.com/alanxz/SimpleAmqpClient/commit/d271adb8a795e6aa98c09507b3401fc4d8ab21c1.patch?full_index=1"
      sha256 "a5d7a26765023728b13fd98e57bf02d4bb9b0fbeb395dd27469c31bcdfb37d14"
      type :backport
      resolves "https://github.com/alanxz/SimpleAmqpClient/commit/d271adb8a795e6aa98c09507b3401fc4d8ab21c1"
    end

    # Fix build with Boost 1.89.0, pr ref: https://github.com/alanxz/SimpleAmqpClient/pull/356
    patch do
      url "https://github.com/alanxz/SimpleAmqpClient/commit/3d3c669608b0dc3ae54e9caae6244bdcc38ca054.patch?full_index=1"
      sha256 "652aad326ace036498e2f990f6fecaa9d2472e04885f581d773fb1fbf3809e9c"
      type :backport
      resolves "https://github.com/alanxz/SimpleAmqpClient/pull/356"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "db26e0a40c159daa4680c3b23a6a53ced0bf4fd240cf181c897c92cd0851d255"
    sha256 cellar: :any, arm64_sequoia: "2010ef5df3e2d1e685739897f2f7ff55f510c406803e16e60853a54299638260"
    sha256 cellar: :any, arm64_sonoma:  "61aa82ec66b12476d11ebbfd6c51183eb6d66f0ecc021ea2eda1c9dfa4efeb3d"
    sha256 cellar: :any, sonoma:        "74ea0b00190bea3b99f3f652402b81a9b0786e64fa6e1cd31a1bf124086d3017"
    sha256 cellar: :any, arm64_linux:   "4a6373da70659b19a24922cc54a37e7ce7b55ea0307d3b5c9f5c11866303e931"
    sha256 cellar: :any, x86_64_linux:  "2cdfe62960ec9f7f73f87fb90fb2b29a78767a794a5bd20cb3730392b683f4a6"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "rabbitmq-c"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_API_DOCS=OFF", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
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
