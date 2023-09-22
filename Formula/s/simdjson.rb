class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "a8c9feff2f19c3ff281d42f0b6b4b18f02236513b99229756fa9a1b14787a58a"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e025c15b4f77b6ed2ee62694ac527b1543b505472729efe0feb80de54293ad9"
    sha256 cellar: :any,                 arm64_monterey: "17793172bdecaedf876743ab66c87743db10280ae1f52a3ac43dcab00b9956e7"
    sha256 cellar: :any,                 arm64_big_sur:  "7ac0e21449cbfaa2c6f932e95cb6b478a37cfb687450a3fecf55f2a0cd313371"
    sha256 cellar: :any,                 ventura:        "b93d45e60d0cab1a7210f3c3393003f880bcf511222996c0b1bd22f75132254d"
    sha256 cellar: :any,                 monterey:       "2ed2ffa4846113821e676e379b72e228b7d516502bf8c2ad2c6047dc8d857890"
    sha256 cellar: :any,                 big_sur:        "04a85dc9b9fc64f7a2234e620678ed2934a241dba2f0ed9671d4e5c2275baf26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68daf26e641460b3e7c2b2762660158dc44469f1ff21df98f2b90d6c9c42383f"
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
