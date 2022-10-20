class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v3.0.0.tar.gz"
  sha256 "e6dd4bfaad2fd9599e6a026476db39a3bb9529436d3508ac3ae643bc663526c5"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "97121057418c1413ac5e1dff59f38698aea474d53663ffc44ddca58e7bd9fc51"
    sha256 cellar: :any,                 arm64_big_sur:  "8b1bef7847d9ab5e3435a99041010aaab98ca2be2af078337d385ea9427af28e"
    sha256 cellar: :any,                 monterey:       "9bf54fef4dd79b2f0d665d815073b4f895129128f0caf59879291a39eebb929d"
    sha256 cellar: :any,                 big_sur:        "c5fa9704b487468f233542ae100fee187891291dff86fcaa946cc04c4784b86f"
    sha256 cellar: :any,                 catalina:       "7e194d8eed7911f89856a315fdbc4ad5dbc397991717234ed7ecdbb93fd673b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2418ad1291706d139fa7c2028c8e3f5dea071f8259fa341fcbf2a328d3cab3da"
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
