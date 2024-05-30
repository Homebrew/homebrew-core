class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.9.3.tar.gz"
  sha256 "2e3d10abcde543d3dd8eba9297522cafdcebdd1db4f51b28f3bc95bf1d6ad23c"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "18fab5e146eeb3226ec74edb8ef92a742950310058c3f1c6ae6348f3786684e7"
    sha256 cellar: :any,                 arm64_ventura:  "48a565eefe10ac8c1d9096b8859fc99f5d9b1ccb2b428e5b23f4d6cbea6532f9"
    sha256 cellar: :any,                 arm64_monterey: "799fc551f40e6c418c324d92ba87ad14697c8ee11daad25ebf1cce1722c66230"
    sha256 cellar: :any,                 sonoma:         "38b5cbca7e78ec2033c6d10b10469cf3088831c40eb78ceacd39b7ee59542670"
    sha256 cellar: :any,                 ventura:        "84210adc50e415ae8e6d6b46bbcaab45bb5fff9b230b1b8a3a51251171316cd3"
    sha256 cellar: :any,                 monterey:       "c6f10a414838b410edb469c86119cca6c0b56d57966150a0ef63ba10bce738e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9340bf3b089a93797b8aa59d354f231f031779f8835359e694ae1224f59752c"
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
