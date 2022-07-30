class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v2.2.2.tar.gz"
  sha256 "b0e36beab240bd827c1103b4c66672491595930067871e20946d67b07758c010"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cc24f449f91ac33cb2931fcd1491d528de1e6395d9fe4de8751a4de25878dd54"
    sha256 cellar: :any,                 arm64_big_sur:  "96adc9a12bc1ddfcf931572999b5a60751edf31495dde4660b6c2a8e2026daa9"
    sha256 cellar: :any,                 monterey:       "d5f897ac2b690c8fc38ed6fb28dc0bd37b0a2b3b76a0dbe9de2c03deb80105a8"
    sha256 cellar: :any,                 big_sur:        "56fa91e5f99514969c46f2522ee508e5c1a48a96324ec694458e8ffc4975288b"
    sha256 cellar: :any,                 catalina:       "f0fd98f413d272b28b410b8d713b4cb01ec76f4713bfd8fbf51bacf6b472b14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14ce20dab2f522103b53222a2d8909c2a637c6e6f93348e60ba40b6afe0d96d0"
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
