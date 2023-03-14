class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.1.6.tar.gz"
  sha256 "ad1462fde83b00f37a320ce5387a4b9c3eba5e3e107a880e8362d7ecb64203d0"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3bf837094dc61ccfdd480f4e3e291d9cdc9414d1b6bf5fe7a7d72037b5ca36ed"
    sha256 cellar: :any,                 arm64_monterey: "bf2f29096dfddd36b6840573a393e48a83e450ed69a07d92a2a6fe9966b5f87b"
    sha256 cellar: :any,                 arm64_big_sur:  "bff420a476c000ad089a495e55eae53b46e64c929dddfa5398f42fda066d149b"
    sha256 cellar: :any,                 ventura:        "830092aff7fbf536e8091a5f5acbfb1d47eef0241af23691e23d6de3fca8f140"
    sha256 cellar: :any,                 monterey:       "e87a7e984b5be6452c74ff3b0807eb49d9bef04e70be19a0a0585320c7431f17"
    sha256 cellar: :any,                 big_sur:        "8bdd499ae286d66441ed38bee886f1c68f0dd42a632047cf4229e50d08f2c65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d320e06cd8a81faac00eeb727e3a5ea801e08f2e5b299808d1b7443b27fe3db"
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
