class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v2.2.0.tar.gz"
  sha256 "011974352049e986bdcdf64fc807cf3ab901865240f4ae8e3de670dd42aab099"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6bbe7617e124c86fb5b00e4723be2529150b9d93ffd0b148c219e3bb365e628f"
    sha256 cellar: :any,                 arm64_big_sur:  "4b09cfe5e74f0827188f53dc20aa5b60e9bed4f196a13b876a4a5a0a8b5a096d"
    sha256 cellar: :any,                 monterey:       "a9eea06b13a70bbde11aa31215fad801249a3b5c8a477c9e050825d23996cf00"
    sha256 cellar: :any,                 big_sur:        "12b72404efa91a3a733051c4105eafa9eb6ee36a526f9d07f1494c9c92cd6602"
    sha256 cellar: :any,                 catalina:       "5f1da7b7786d1345b1bc9b90ac3316c23e0362f3e3420a1adce033c6414d66bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "497aa3818dda6f088d37f57ceba4acb1f486c859e08326d5663e85ff9c9dc190"
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
