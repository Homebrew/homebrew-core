class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.1.7.tar.gz"
  sha256 "c65f5184fba321c7b9e97f6c881af9b607457bdd60fac0467010e099121540e2"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "071e76c1589cc33bb01c904a19a53fdfc837053275794ffc161c94b5560ee5f3"
    sha256 cellar: :any,                 arm64_monterey: "7bd396204be7b35471e1cdfc04a6008ff798412b423fa51f40960ba6333abcef"
    sha256 cellar: :any,                 arm64_big_sur:  "4e89d6daa42cfaaae95656e4354c497035a78890ddb9119091f3925f1542c00c"
    sha256 cellar: :any,                 ventura:        "ce06c9b72e521cd53ac764e7e96151244d7a880ab1e88793763eab592a990c3c"
    sha256 cellar: :any,                 monterey:       "764820a47dd9689933a10b69c51ea6325f99aec414edbfa18f3f04122e1fb339"
    sha256 cellar: :any,                 big_sur:        "d1aaf7364817857b707c4a3afe3961398114ac5dfc8698a5b913e08da83a1f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df575bf3ed22278758ae9388d46373811d8eabfea4dd39834a0ba152473c2da2"
  end

  depends_on "cmake" => :build

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
