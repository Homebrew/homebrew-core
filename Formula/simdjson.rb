class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.9.4.tar.gz"
  sha256 "00f73c19e10af0f9b128a95ff584f84b20ff94b63929ba1214b1867d35838987"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "930824907cb2b3daadd2fc0ad9a45ea59182bdcf259eb134040a2bc59586646d"
    sha256 cellar: :any, big_sur:       "fd340142e49da2770fe0e11dbd0925339b46369c6a61efa2c6387f19d422e88d"
    sha256 cellar: :any, catalina:      "77642d7cb2ade06ba062526d0308db168b43587aef9960bf1b09f2bf3a679590"
    sha256 cellar: :any, mojave:        "f007d86d33ff14396d18d532682ef1833ae021bf7c1b3894a691d857e5f994ac"
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
