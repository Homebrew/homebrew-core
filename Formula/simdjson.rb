class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.8.0.tar.gz"
  sha256 "0279e453b8468b95d810aea8d27c7c17b86c94d906ebb318ba07cd05914c8ef2"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    cellar :any
    sha256 "b605301a14620b41253bde6963ebe3ce0905d3c1b1aae40a3c7a262a32b317f2" => :big_sur
    sha256 "129baa718037520fc4bedac4f455101815dd990b24c4a9f9ef24207b3905f6cc" => :arm64_big_sur
    sha256 "39fd0ad985dd077d138b152b396e90163782b0cb712e93d425706cf315ddc97f" => :catalina
    sha256 "f3c1ff931f4cf8f1fd707e5324c306868a9e1eb3b669af4dec197a269568dc83" => :mojave
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
