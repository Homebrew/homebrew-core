class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v3.0.1.tar.gz"
  sha256 "156b1bc5eb0561b2bd166b46d191fd3d95a3e709cc63761477d3b7aec2b6e9ed"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "80b5cd728a271af924f7e743cd416e69b11009005734bef73ae5ccc8c729171f"
    sha256 cellar: :any,                 arm64_monterey: "5f901929ffcfa87d9943255a6ce3bc7e9cec00bdec4b318e235e4bbe5c0ae203"
    sha256 cellar: :any,                 arm64_big_sur:  "63bbb93cdbfa02d0f047399ad514a29a707ffc0b2203ef944500ca4995c39d20"
    sha256 cellar: :any,                 ventura:        "7e91bcef1a0caa980378d2b34158ba9d1ba60027e1d981b854de66ea4c6308d0"
    sha256 cellar: :any,                 monterey:       "29ae95d05ab9363c1b2eda0bc6e252f09f00cd0f1d41821df0a07eb58b8dc107"
    sha256 cellar: :any,                 big_sur:        "8eb716b1b9061945789e959083d1689739946b0d9a69165765662230c6f2a420"
    sha256 cellar: :any,                 catalina:       "b018b250baa67b306782f7de14df5b4071f13756b1ed873096dcb197fb5fedce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0596803f54131f2e190e8519260b75fd085fc911b01177313e02f2b80e2d4ee2"
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
