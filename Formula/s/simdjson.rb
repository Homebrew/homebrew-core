class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.2.4.tar.gz"
  sha256 "6f942d018561a6c30838651a386a17e6e4abbfc396afd0f62740dea1810dedea"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2da9015567b405320857b329c62fce8de561cd44339cc38a6bc8d50e4b995149"
    sha256 cellar: :any,                 arm64_sequoia: "3f328ffe15e6752a84c8f7dc9871ec9da9b8f4893bc8d45697aec7a60305b098"
    sha256 cellar: :any,                 arm64_sonoma:  "b15638002b457909a564b62e341332f140bb288a13b538e39675d24c76151d9a"
    sha256 cellar: :any,                 sonoma:        "f9daa286ce22fb0e87c6db7b0b17b2a20b256c35559e0bc60260c01a3ed67ae1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "176495725b7aacb62b5c08a1a720a9ae837af2b36fc456e7b23322b171253b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c61e174e7146d382083f2e27a3dd6e968abb9dfae5d0c8750d44e02e02b9ba03"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DSIMDJSON_BUILD_STATIC_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.json").write({ name: "Homebrew", isNull: nil }.to_json)
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end
