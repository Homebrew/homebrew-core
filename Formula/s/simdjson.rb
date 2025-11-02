class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "cf294f624bab25d6e48f2c5380192f839055a7c0e82a77b454f5fcefdb02d07f"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6215418ab15d56a9c0efbe70c069288d3e582da1ff0731f7bf706e76dfa44a51"
    sha256 cellar: :any,                 arm64_sequoia: "9437eae75ec4a4c288876b96c55a2090493bf4d5f40e51ef148bf511ff0a8bd8"
    sha256 cellar: :any,                 arm64_sonoma:  "af4202808ff33ffd6396039696ef7244568b043b6b780f5ebc4b322f06ade982"
    sha256 cellar: :any,                 sonoma:        "ea392576080f409b5ceee35437a246a0ac74ba35c3abffcd20077120a147f104"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60ea8614b577058209656714b9af4acf9e1dce907ed3cefe05dcbab21b36894f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d0ab1bdc588ed0aa7745e8ff67d289feacb00fe4e5715e30b486f932fc2ee99"
  end

  depends_on "cmake" => :build

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
