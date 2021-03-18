class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.9.1.tar.gz"
  sha256 "05a78fc9410ae2f4febb5855ecb44defb956c3a23c73a77eb590aa7a5a8eb09d"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "22194c0e3ae0b279e6345580e07c308948bde941f39b72fcbd17e0b27e391f6a"
    sha256 cellar: :any, big_sur:       "04b3994ea598204c93809c4987de4eff0e3848e5c273a01b8b30455dc82dfbbd"
    sha256 cellar: :any, catalina:      "a6e4926b044a8c862a87259d6c6fcb0450fd917cccbe94d37a50195c85dc57d2"
    sha256 cellar: :any, mojave:        "d9af68350e61fec2fdf07bd55d1a4137079b1e692fde4d262126a411c8efa8b2"
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
