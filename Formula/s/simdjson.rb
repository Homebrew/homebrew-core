class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "e28e3f46f0012d405b67de6c0a75e8d8c9a612b0548cb59687822337d73ca78b"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6fb98a55e921e8273f75efc9f6587c52db39007b73a7e70424719fe553fc1ad0"
    sha256 cellar: :any,                 arm64_ventura:  "3738f7254814562550dd90bb0fc7586108fba15bddcc4f066c122f09e54cbbab"
    sha256 cellar: :any,                 arm64_monterey: "6c7a407f4d6b6e89f4a3abbd2ad8b6fc85cb773276e2cd11cc6bf26a6e9e46c9"
    sha256 cellar: :any,                 sonoma:         "a3ac8a674724abf72937b3568cdf70e06071e68c7eb52ffb05968765fd403eaf"
    sha256 cellar: :any,                 ventura:        "9fbd886b7699761a22808e89f4d4ee21848c055fe86fea51302448db92e5f8b9"
    sha256 cellar: :any,                 monterey:       "471693828051fc4bb0a221ebc7d6b6b23740492c8c3c6addf4f76ea29e5d3fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70040b3a80867c050017d761f755b3235e57714af0d3b2c0bc51826020f71763"
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
