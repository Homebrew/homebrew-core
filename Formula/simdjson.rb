class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v2.2.3.tar.gz"
  sha256 "4c62f2d82edec3dbc63650c10453dc471de9f1be689eb5b4bde89efed89db5d8"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "07203273ecbc3c98d1980a020b8ed37a23fe4d97be9e6c46abb0e098a0369494"
    sha256 cellar: :any,                 arm64_big_sur:  "b932119b0545706455f1d82f329b4129f3a78ff0f241b466a941843cb74e9e51"
    sha256 cellar: :any,                 monterey:       "789e8baf37f7c4047d1e65854fede479a92e9d23924ed3fc516b31cd8891f239"
    sha256 cellar: :any,                 big_sur:        "8896c46885c432f84db3eaa12a6e02d58582478855dbb4825caea6161328002d"
    sha256 cellar: :any,                 catalina:       "66a48ed81f33ba5b36de8ff0eeed782c9138d8c4078e1ad9307d8f44338fe04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "986f9ccdd81604024569cdd09bdb0d3a100646f10fec6c8986a2abc4bbf8a223"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

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
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
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
