class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "75a684dbbe38cf72b8b3bdbdc430764813f3615899a6029931c26ddd89812da4"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "326398ef2720fc9aa4e711104cd15a9cd7f22ac73f7486a348258368d14fbceb"
    sha256 cellar: :any,                 arm64_monterey: "e8512fa489d8292390ebc4b344389451440d4062962bd5d5791da34e0a2a6b67"
    sha256 cellar: :any,                 arm64_big_sur:  "7a87710d893499a0bf74540f4a7bc89abf2174bece40c25992549410dfc73cfd"
    sha256 cellar: :any,                 ventura:        "adb4433ada1853c4f19d70c91c7d2eaac94f59793e9ebc9754108394eecc0d35"
    sha256 cellar: :any,                 monterey:       "38c3df22ee635e19796f4cffba0806d22bd4c00b30f57c34aa4fbbdcf2b325c2"
    sha256 cellar: :any,                 big_sur:        "cbd896d61a4348946fb462929d1aba50447c35891f92d01c4352e3a631b307e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eca7b702b958e21b2e4c6e2264127fbcc2aba27b22b5743118e1938bfcddc02d"
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
