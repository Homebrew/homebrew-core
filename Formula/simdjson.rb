class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.8.1.tar.gz"
  sha256 "761c137d1e85cdd68ca259f9554ad51d3cc9784f6b2d4f6dbaeb999dd11947b8"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "57ea9f705070a10bd95ea9916153c50468a40d8802abda87ea55846f8cb13c05"
    sha256 cellar: :any, big_sur:       "54512855b5401c9195931c8aaee8af225efac53c776efc25584683e070a0eaa8"
    sha256 cellar: :any, catalina:      "6bfe4056f1fafb715a290cb194b0daad8164ed5fee6c75f274bf4d62228b83c3"
    sha256 cellar: :any, mojave:        "ea39bdc1c8a07cd37e0fa04dd11f33705c96389b55f61de5a1e262ccb2a2abfd"
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
