class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v5.0.5.tar.gz"
  sha256 "50bb17769e1054ff1bfcd5dbbfcf33544c77f6ebdb31a318436ea0e47f78f571"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7fac416e0231f3bcb90035f431c804d93799cc3d19c58ad916e7ab5cb52ab122"
    sha256 cellar: :any, arm64_tahoe:       "a1c0c967c143c236fffac1266c93221f132e7822a2cb2b00f1de1d056ca6420c"
    sha256 cellar: :any, arm64_sequoia:     "ced6abc11f8e79cdf8450f93c665ec435c4907f1c93d9cc6c92f3427e6d07532"
    sha256 cellar: :any, arm64_linux:       "a9a051e6591da85cfa126a9e45a6e6e2cabb79cf9d35f6e316e266ba3e82fbf9"
    sha256 cellar: :any, x86_64_linux:      "c7f596a9c1abdb681aa7204bc2d77f4547080b0ad3af3b2bad7407a5df3e43d1"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
