class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "d669fa399613c20bbf7705f057a72984331b223cd5e8d20666ef063dbf97f3e6"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6bd70e7f557eea3b8fb88afc9f590570235c8dcda4926fac9d137e4a4afba9dc"
    sha256 cellar: :any, arm64_tahoe:       "5099780a6ee4e137939865ed699b3de615960e7c9b1abf89dd113fe92407b3c4"
    sha256 cellar: :any, arm64_sequoia:     "6b3d968cf40394a1bb5b3a1f5d51d5b4951b3c6d13ab76b686d138a748f07c3e"
    sha256 cellar: :any, arm64_linux:       "0bc653c7da005d4fec1bcc6a5d8c66e1d1a581dc4182390da24a1f5cf0722057"
    sha256 cellar: :any, x86_64_linux:      "7d016e1783d93c8409f0b92a3317e130251c6f2f76cf5baea589d0c1708f16ee"
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
