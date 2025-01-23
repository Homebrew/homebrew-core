class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.11.6.tar.gz"
  sha256 "7176a2feb98e1b36b6b9fa56d64151068865f505a0ce24203f3ddbb3f985103b"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f81d37e97b04a943de8ea24d8d8942de941d49e1efe1e878fac085c2e260826f"
    sha256 cellar: :any,                 arm64_sonoma:  "e381d8c87f1a5d6bb2d03a4594b9009f84db444198e52d28aa26fc2aca12db0a"
    sha256 cellar: :any,                 arm64_ventura: "3cd7ad1e2442d6f74b6a0a199bb99dffb1e2071b7162fb1dfe84663ab0835173"
    sha256 cellar: :any,                 sonoma:        "aadec7dfee8160cb4cdcaed5a5e02628dd9af8355b8f44a663d8191f57256b37"
    sha256 cellar: :any,                 ventura:       "64a1830978ab3cf10f684e8945c3303de7e3b9a3f9717bb474d7467560eded88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6316751c4af672f92f3ea81676e6e33d6042a2ebb7e128bc9e906a64088f1d83"
  end

  depends_on "cmake" => :build

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
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end
