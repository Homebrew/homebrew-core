class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.9.5.tar.gz"
  sha256 "db69582fc5e4ece8c0a6a64894efeef475fe22fe466bd67195422de11b08b4d2"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f01368a0197d2f6e8812ac5117ab5e7d4e55dc39b43891b6aa1cd79d138bf855"
    sha256 cellar: :any, big_sur:       "be88861720cbb1e6562431f7496085be4e27df2e46fdbdb059e4be77f687e05f"
    sha256 cellar: :any, catalina:      "ff09e927f17c92bf1258044c958f28baa6b649ea70be66eebbb9cd785b8e1442"
    sha256 cellar: :any, mojave:        "5596e68ac63e59c313e07fb3ce5ec2a8cc594255f023600089c88b544be4f1a4"
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
