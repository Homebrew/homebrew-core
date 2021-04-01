class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.9.2.tar.gz"
  sha256 "5c04b14404998a92799a737b1d9ee47268de831f32f959f6b04ed9ae385cd80f"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5a60642265f895fd725b609fcc7099eb198951267192857be1de341992e04f45"
    sha256 cellar: :any, big_sur:       "bf0ec3f5bfc57ab0274305ecea52e348552cdb44a98d9b3b0bbb5257c0aca568"
    sha256 cellar: :any, catalina:      "71e0a51cd4f714491b84fb894511c73d58918366a93dc6667ac12b9fb92a6677"
    sha256 cellar: :any, mojave:        "83b64f79d66fa9cb8daf3a5241843b7ef260e0c665d563c98d552e04aec146d5"
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
