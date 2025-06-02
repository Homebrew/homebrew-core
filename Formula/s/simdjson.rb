class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.12.3.tar.gz"
  sha256 "d0af071f2f4187d8b26b556e83ef832b634bd5feb4e2f537b9dabbd334d4e334"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3eb49356f9c6ccce46cdf627e8ebef557bdd1817776f8bdd3653bd4c92b8802d"
    sha256 cellar: :any,                 arm64_sonoma:  "7ec78445ccd839b7e8a11f6994561760d107464f157e82cfc049095438bfd5bd"
    sha256 cellar: :any,                 arm64_ventura: "a9ca3f54731c3af437e7de669542e08bc41ad9898963e464a245a151368766aa"
    sha256 cellar: :any,                 sonoma:        "3f4509080df7f6a9bb9f6d1b67c766d3172765e0204fc4b694300e35371b1c73"
    sha256 cellar: :any,                 ventura:       "09043e27cafd7a7802e2220954f18f9a158e9991376d2fe2c0997546861a2b1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e15d466abaa6b3ebe4c2271aad04730811e432d1f1b9ef0adc6dd716bf1c4028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2564b875d68a2b94647cdcc5c611a1ba8d75269313c673174119442fed5e6ea6"
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
