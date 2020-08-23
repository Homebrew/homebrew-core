class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.5.0.tar.gz"
  sha256 "60846ae482e17230e41f5abf8f058a6e367c2a0ec1b5a6fd7a883a54ad21bee8"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    cellar :any
    sha256 "12c86e70c841b45c18a6d8a89e85c7bf8ddbd9e267c749e4f217013eefffae06" => :catalina
    sha256 "f678c4db06a8c4476a9c89d53e3847dfd077e7a1d075bc86720d0ad1af168ef8" => :mojave
    sha256 "b4e7a6dca5f6045bd6450c691e95442458ce75576fef5eec19b2e3816099c499" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + ["-DSIMDJSON_JUST_LIBRARY=ON"]
    system "cmake", ".", *args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", *args, "-DSIMDJSON_BUILD_STATIC=ON"
    system "make"
    lib.install "src/libsimdjson.a"
  end

  test do
    (testpath/"test.json").write "{\"name\":\"Homebrew\",\"isNull\":null}"
    (testpath/"test.cpp").write <<~EOS
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
