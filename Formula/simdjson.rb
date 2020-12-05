class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.7.0.tar.gz"
  sha256 "c814f7e20103cded7c2758ceaf41f9f63febe8914e7e72dd1daf1d6071aba8f0"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    cellar :any
    sha256 "ddb4e012c0e18dd1b014686c0f5e80e297130742206ac01ab0f2e3a0ad45e2fa" => :big_sur
    sha256 "e0b2ae73582ead699b984b3053cb2776122683acf70898bbd48a4d3603b432fa" => :catalina
    sha256 "170cf2d9057258edf1e1aa6db25ef201419f2761b63709592e797bedd72450c7" => :mojave
    sha256 "610c8b599489b5411d12b057600d27f206c2ca0f08b0491b24561b7e7ef45bed" => :high_sierra
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
