class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v1.0.0.tar.gz"
  sha256 "fe54be1459b37e88abd438b01968144ed4774699d1272dd47a790b9362c5df42"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b3973e31d27a2bbf477ab7b1daa2fe9ae9302340a56f91c6dd2b991af5547ec2"
    sha256 cellar: :any,                 big_sur:       "1544c6932b3ac405e24c7c50f5b32f6918c99615a575b56bae19d29295d47e90"
    sha256 cellar: :any,                 catalina:      "1abef2e6ba683d83371fcd220578408b7d659b9d57c73bebe87b99281b03e31a"
    sha256 cellar: :any,                 mojave:        "f6694a3a2e21b588d3909bd82095a461713021b11aae7d0b683da04c3de732d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eca3b5b64d76b216c71d214b3e5556c62ab92bf3adbc5beb6e0ac0b1ac05926"
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
