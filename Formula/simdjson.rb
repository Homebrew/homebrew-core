class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "4fcb1c9b1944e2eb8a4a4a22c979e2827165216f859e94d93c846c1261e0e432"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d091f0f1e98e1a61c13f63845f3ccc541e82e417e6ce63b1252c2cabb68959b9"
    sha256 cellar: :any,                 arm64_monterey: "4bf3b5b4c29d4fac04289267eadcc143c13374ddaa6d699d8b05b5c56a5ff911"
    sha256 cellar: :any,                 arm64_big_sur:  "cdca0ef5150412785094c13de9f6b543bc1c431f04847c7ae882f6d11bd01acf"
    sha256 cellar: :any,                 ventura:        "c3f74d15effef67527d7b6df05bbae171d68e398d18ffad7a1d2bfbcc1fd2a40"
    sha256 cellar: :any,                 monterey:       "5bdf34abc2c556198e5d0c8bf063cb71f59cdeae0778512340bbe59fb795fbe1"
    sha256 cellar: :any,                 big_sur:        "a23d83f29c7ed45f4164465815ad01172b188ff342f6d10dc246e8f2c24dc9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c34e589b5290025b4792d9e51a604134e6065dd7665503ba1f71dc49e34e689"
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
