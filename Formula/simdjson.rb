class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v1.0.2.tar.gz"
  sha256 "46d5995488de76ae61f1c3bcff445a9085c8d34f6cbc9bf0422a99c6d98a002c"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "518de62b8b806c49f648784dc9b33f2d0c8575029fb4d78a6487ac80cc62b013"
    sha256 cellar: :any,                 arm64_big_sur:  "7c6b11eb8c5b581a872c5070ac1d7134305b419e49baa25dd9c3b3df9024ec55"
    sha256 cellar: :any,                 monterey:       "c4ff0c41fcd758e7c0dd1f20e63830f690c3308999b35dcfb5739e27242180e6"
    sha256 cellar: :any,                 big_sur:        "f2def7a5a729fd09f4e3e6c6df3d82f6233c8e3efcf6e292b650ead95fc3e089"
    sha256 cellar: :any,                 catalina:       "a1c949fe2485e8e76fb0cfdd648f4fa8fef1eb304652a9a11d332ac2408b2625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64093f3fcff9ceff07d1a228c5df8f9d93878c1a01d222b5a34ace5fb5c8f967"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

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
