class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.9.0.tar.gz"
  sha256 "b49fc4c740fc5fd9ed86f53b4758fd8a6416d1d51603c297e09d1379c34f19e5"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0bf2e02831f96172f2f296ee716bd5f076c3707a878a5c5f153e9979695fb7e3"
    sha256 cellar: :any, big_sur:       "438559939a752abcc531079b71bbbad220e6ea57eab9dbdf6c4083e71040f2da"
    sha256 cellar: :any, catalina:      "4206f37add8bb6db8bf1fcfa033a2b37d2993e49737b308410b24e7d35e85d38"
    sha256 cellar: :any, mojave:        "3beef6f598473965d3a281c9db53a262f95d189360d8d25bbdcb9df5686783cd"
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
