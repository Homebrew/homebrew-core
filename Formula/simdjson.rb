class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v2.2.2.tar.gz"
  sha256 "b0e36beab240bd827c1103b4c66672491595930067871e20946d67b07758c010"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3da1e8724adfcca970583feb6dd6b5bb552a9338febfe00666d34c9bd3022c40"
    sha256 cellar: :any,                 arm64_big_sur:  "feef5e1be268521144bd13e1a49d363e19bae056450fb7af43d3f73396955b4d"
    sha256 cellar: :any,                 monterey:       "7a7a70ebfe5989fb8d4fe1e250425acca7d89cf6b42af093b208fa25dea8a646"
    sha256 cellar: :any,                 big_sur:        "707785e8269a6f5090803fb9a5537cbd2c123d6103a170a386caa1c6d34cc540"
    sha256 cellar: :any,                 catalina:       "15e65f4b701a88bc7977c48fe39588bc8ccf4cc373b79dbb1c54ba40763e68d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb5c43d85d3f2c9cdd28c50a64b8d803200897ebc916b1289b5ff80bd8b0ceeb"
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
