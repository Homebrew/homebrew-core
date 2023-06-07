class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.1.8.tar.gz"
  sha256 "99e7eeb0a0038e0213da68f099e6a8b67bcaeea1586385ec5f752bea85d902d8"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9eda4b71d4a262af55532c058d4448a4688d71d79cc2a930064737ce25d960a7"
    sha256 cellar: :any,                 arm64_monterey: "3bd786ff0cf14e9a7e18875b6905de8d4cd39f89eca92ace2b243b7f5b1a6248"
    sha256 cellar: :any,                 arm64_big_sur:  "754998ba0a941e880356ec6341892d81794ec215033278939538ea356ae7c820"
    sha256 cellar: :any,                 ventura:        "7d9c545b97652871743a33c19ad06008cb0bb6e7a4c984059626500487ce3bdd"
    sha256 cellar: :any,                 monterey:       "465b8de79eba411c05c62ac50cd005371287d116846196ceeb4048df5f115253"
    sha256 cellar: :any,                 big_sur:        "df8c5498cefceacc7f0a9d8feab8481305e0c5f0f9997fd27ff2f3a930518a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b1d9571f388e3ce87aaf3796096775bdc8e106eef9abaf85117697ca2cb668"
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
