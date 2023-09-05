class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "ab72701b8560c4f93a5de525657b3bf34094f99a1e63bd9db3195d1bcb90aa09"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34110267a81f39ce7d54677b9c35914011d0e06e281318ef3afdf948bb0bf369"
    sha256 cellar: :any,                 arm64_monterey: "8d47209774c9d129bc16980ca2ac3a2c3a2d2e75586e090e62b0f6c02de238fa"
    sha256 cellar: :any,                 arm64_big_sur:  "054a7ea92c998c64bf388f7de4b1498d383ebf5b4de8ad7926a53844c1fc3190"
    sha256 cellar: :any,                 ventura:        "e66217d2029318a5b0f1f41b5a7037b4816ee05e52dcc64e977f133d040ef199"
    sha256 cellar: :any,                 monterey:       "e75d1dc3cca52900510b2c1ec2422fdf82147cd82e82d3c4d53cb93c8297403c"
    sha256 cellar: :any,                 big_sur:        "a8d5810ddb175bbf268df0048eb8f6a59d814c58238ec22d5b513a5335905eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b6f25dbb9df555dbf54758d5d7eed04365038ddcfae7331350156b7c9e6eb4f"
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
