class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.9.6.tar.gz"
  sha256 "ffca979ad1f0255048db3054942788efa21f05d8f3ad8faa5aeb61e731e13d6f"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5ed541fa0cd4f1a8fbeb88560f14e0f038bce8da5b46b8a6c07bc80fbe9146e0"
    sha256 cellar: :any, big_sur:       "37c283c7805ffe7443ec959af50ea1822d6afd706826cd342b28192d3c63c72a"
    sha256 cellar: :any, catalina:      "acd67011d16839d823324b6f23067c835f789b8463c7cd5c001723920856036b"
    sha256 cellar: :any, mojave:        "a3d828775754c24266b57f3980ab73357c0f7015a7256d283fc6fc4fa5969c53"
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
