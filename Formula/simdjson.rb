class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.9.3.tar.gz"
  sha256 "6f488b68fae52dd634b5b9d1c046db6dd9cab93c881ed3842415c20fb116735c"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "eababe44783c195319130fafa2f855177e251d97b04996c23230fd44e349a215"
    sha256 cellar: :any, big_sur:       "9a046502b398360575afb1bce0fe6419d29372f629fc7ac5979a41947c05484a"
    sha256 cellar: :any, catalina:      "60be38162f196e9d7caf42f5a3fa94272e03ba619905a98499fc6d35b9eb87ee"
    sha256 cellar: :any, mojave:        "2b262f1d706451b6d2b11da1d157126e27a3a8482dcf9f628b984220561e962b"
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
