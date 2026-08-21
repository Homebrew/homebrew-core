class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.6.7.tar.gz"
  sha256 "3bae37c1b215fc28a32db09a8c25513914cbbc1494d768e593d1b9135c8c0fd4"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c68e6b5a20dd26ba109a28bfd01dbdd7af052c0373ce44690451c54a0570a3c7"
    sha256 cellar: :any, arm64_sequoia: "c39dff1fdd578a9a421e88945e7bf87284e389b4f01a98b08ec7dbc1c2669879"
    sha256 cellar: :any, arm64_sonoma:  "d7a99f2d099b48ce0df67207dee3a0961ed2f7ae2ba7257b2134e555324bdb37"
    sha256 cellar: :any, sonoma:        "a48d7a6241521def621d70024993c9dbb5a422082bfa6e782ef2760d365139f0"
    sha256 cellar: :any, arm64_linux:   "de851878c9e7de7d293712164b1a3bb9817927d620df620577c23b543b6bfe53"
    sha256 cellar: :any, x86_64_linux:  "8b4cc8c9373b9a9b53a9dfe867e0e20440a559ac864c5cb7f78b65f0aa067e7e"
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
