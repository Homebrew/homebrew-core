class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "9c30552f1dd0ee3d0832bb1c6b7b97d813b18d5ef294c10dcb6fc242e5947de8"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d8e2627436a1a901be1a1f7bd37ef51ea183d54e49dcc81484ba8b6b01256261"
    sha256 cellar: :any,                 arm64_ventura:  "20eb75ecfda5953d8665a28a1f950d3f6243e1d2f9396437234288f9249bb7e7"
    sha256 cellar: :any,                 arm64_monterey: "679e6ed09dba75190d38272a1b7688aa9c91df2026687c5332bc1f13d0c28a64"
    sha256 cellar: :any,                 sonoma:         "99ee30de5d6d307dae22b710f41aa22bec147d986853b7f40df31658cf6838b8"
    sha256 cellar: :any,                 ventura:        "474380c6683a572acd4e15f49c056a9e97addb28445852f085c4188b941ee9e5"
    sha256 cellar: :any,                 monterey:       "8a98f7a9cb228b3910e4a5b03352e1d04f1adc86532f5a24dcf66930f918d957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "212330393bbf8574fa45469a73369226c39310e1ce6cb1f3785adc1c7260bcf2"
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
