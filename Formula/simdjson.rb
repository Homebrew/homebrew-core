class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v2.0.4.tar.gz"
  sha256 "c8a12cf60f6ce8c0e556f68bd80e7bd9f11f5876e198ed3637da8ccf182eaa24"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1cb96843a02c5e9719d0e97489299c9be9f171e06ba97d4f0a8d70e635b3f8ad"
    sha256 cellar: :any,                 arm64_big_sur:  "30280c9ae975e560d4f5807918d0f8908968b1d58c9fc97e1da5b3b7a24c99d1"
    sha256 cellar: :any,                 monterey:       "2c0abb6a73fe140ed68387893ff0fc24322eec52b7c843eb5df1eec8464842cc"
    sha256 cellar: :any,                 big_sur:        "64a4f8bcea7606c62768ddeb11a0787b48f7ff54b634543524f9ca6de78347fd"
    sha256 cellar: :any,                 catalina:       "6a71cf68a95cb6c9374041c82fe6ec0d4846f34587f796782cc15dfe94f31b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f73368d388cd613a3f9db6bdb04ddbde49de10ffe635fcbe68a7c54b2d756fe"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build"
    lib.install "build/libsimdjson.a"
  end

  test do
    (testpath/"test.json").write "{\"name\":\"Homebrew\",\"isNull\":null}"
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end
