class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "e22bd6a9d3ff8a7ab9b27afcca12a8ec91adad22d987fcf798795cb3d1e48941"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "92371ce7da1ed71d0bdfad9518bb9c1290f2daaac85594fea3350a9c1443de1d"
    sha256 cellar: :any,                 arm64_monterey: "7d62ac359720458b531af883a8b6abc04b027ca317ba2d6a4fe23bf733787367"
    sha256 cellar: :any,                 arm64_big_sur:  "7c0cfda076f1a4e02208c3b810e2f10abb0b1fd82ca93f4fa4d4818474453b8a"
    sha256 cellar: :any,                 ventura:        "caaefdd5b90aff13608a26558e54068012c0f45c7ef5914d12086df04cf448c1"
    sha256 cellar: :any,                 monterey:       "0153b7bcacd3ad0d95ec544e47395eea00ca0a2bccad0d396841bd579cb9dd35"
    sha256 cellar: :any,                 big_sur:        "315dca7cc4890393ff3c4961eb067305d1c0addf11ebd7499e5de60120faa959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61634127f7223c125bdedca2b988822e2220465d2434258bff0547e2784431bb"
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
