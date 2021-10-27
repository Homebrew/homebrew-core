class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v1.0.1.tar.gz"
  sha256 "5c6dea254c3c13d29c85437cdb01af498551f6820c0f5b15621216bd52549290"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "695a571b0a3006b806f0bf5713fd6b753a10c0e764f3babebbb5b3fc23338e80"
    sha256 cellar: :any,                 arm64_big_sur:  "b14f67b6f82b861329cfbcb28585f889a73285a9a0f3851e5e51c3c180e73908"
    sha256 cellar: :any,                 monterey:       "584b19f49f0cbf90174aba32a015895d91aedcc1472e6d53a93ef63465c10afd"
    sha256 cellar: :any,                 big_sur:        "54906dad9a15dbe6cfefe33a28c167b0964b64b2413126bcf18ed0c0fc40a733"
    sha256 cellar: :any,                 catalina:       "4017b4e21af561ee3f4929e12baa338a947cdb55767a00194c00fb74a31f5277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc6f207f238e8f57504bf9e4299d931bdcdcb72301e27df41d525879e936a27b"
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
