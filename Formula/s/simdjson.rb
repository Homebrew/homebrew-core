class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "13a702536e051db612cdca82bf8585f2c69d9c6fd156ef291b170f13202c1b4c"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e53c544800138cf58052c9696488a33c5c472b2d23759330f1cb19fe1b2cd9ef"
    sha256 cellar: :any,                 arm64_monterey: "7a993031ffc73b24fe72fdf54756c4d209260ec061faf92acfa55b439df38c04"
    sha256 cellar: :any,                 arm64_big_sur:  "c0738fd688a0cccb59a23a1dd1685236eda7777c9f1d89dc4b02f09163f8e916"
    sha256 cellar: :any,                 ventura:        "e3893dd393d0dd1e3efe1940f1cd3da37c547d5de75750d6ce02560b10edf5f8"
    sha256 cellar: :any,                 monterey:       "e2c052c5cc7eaa144c40a8e2930bd95b25aef6a39af9e414280b3a4bf24f4634"
    sha256 cellar: :any,                 big_sur:        "4888e12a86a07642b8ec370e52c80fab49a045bb56e8dcbd7b1fb05b28d1bc1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f910a3eea3455fb1902728ff7055cf16834fef68993ae8145c00fcc5dd775213"
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
