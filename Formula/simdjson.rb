class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.1.6.tar.gz"
  sha256 "ad1462fde83b00f37a320ce5387a4b9c3eba5e3e107a880e8362d7ecb64203d0"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5072c566387801e7745a112a33d42889ab1350272c6521e0a841a3e8e525631c"
    sha256 cellar: :any,                 arm64_monterey: "4431abd5cc63dc8d8df8bea6a3ee822203a60e23872d8b66550c7b0982e7a3d4"
    sha256 cellar: :any,                 arm64_big_sur:  "1bf74030e71480a310e55ebeccb410ff0f764c6f6f26d219d6b48572ddb9cb65"
    sha256 cellar: :any,                 ventura:        "22326ed91dc15b7d1c5c77237ae5c91b855a8f2f44fcdfbe9b0b4563b3dd5dbc"
    sha256 cellar: :any,                 monterey:       "491ad7743895d052aa0865ff2a98731b8cda8a7c021bc0322591217b278478fa"
    sha256 cellar: :any,                 big_sur:        "bddb9ace9ad15df1b6ff3bfe1d366bedd5b76eee6621dbf40ddfb628b895ca50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "284d350dbe0018c5e39d8365012b17fc4a16a8efdfbf5b1d15a1d5f4ae02914c"
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
