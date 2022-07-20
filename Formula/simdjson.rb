class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v2.2.1.tar.gz"
  sha256 "a2a22b9e1cb7310bc3957763f51b4526a60ab6f4db777d8f728f14ad8ff69e3d"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a1a7edefc038ced04f53e5b2205d769f4378d16ae90a7f2d70fb82b6f9c3ac79"
    sha256 cellar: :any,                 arm64_big_sur:  "4b43f7ca4df0141de209670210425bef011cbd4fac7f29bfb386afa712c4e86f"
    sha256 cellar: :any,                 monterey:       "16e38cbbef6e37652c334596f25b90fb6309c991fbcb7eade96b8ab3d14fd2d0"
    sha256 cellar: :any,                 big_sur:        "1b882344441f28a40d5178a355e2e7fb1a946410ec5078386326e1bcfa52ab0d"
    sha256 cellar: :any,                 catalina:       "38e4d994fa7725b837447d41dba6196508f726ac35ad30f585543fb51020512f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00464dee0b76b85a8e9d0c3139987158913531d5d4a0a61de578b531a7255fde"
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
