class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.9.7.tar.gz"
  sha256 "a21279ae4cf0049234a822c5c3550f99ec1707d3cda12156d331dcc8cd411ba0"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "de8aa7c888e15197fa0b143b10136abe39bc479d7d47a283f9ffb87ba5bc87d4"
    sha256 cellar: :any, big_sur:       "4552d7517d700aab4fb52235db8885154f3227afeb99c3afcdd7b9895775ea3e"
    sha256 cellar: :any, catalina:      "47a293950f8b604ff3f40b8c60a23eb6cfcbd9411b96f3e9f4458fa681297999"
    sha256 cellar: :any, mojave:        "aa11523cf29951aa4dfee2132745cd077116230fae4345f5671356514b9fe7ae"
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
