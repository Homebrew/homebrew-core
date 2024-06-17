class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.9.4.tar.gz"
  sha256 "9bf13be00fa1e1c5891a90dbc39b983e09972f0972a8956c20a9974cedfcca2f"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "379df2e7e97272724761328d1e6f34e484c10195259869280a15b61fae99df23"
    sha256 cellar: :any,                 arm64_ventura:  "19e6a7e52b9ed4e2d465517a9b5ab9cc5bcf177e1509cd194d70393ddc23c182"
    sha256 cellar: :any,                 arm64_monterey: "e29c3cb67e6c7a346cdead92434b31e538fbe08abd35c9b78c93557fbcbd01cb"
    sha256 cellar: :any,                 sonoma:         "e51edd4c972b90b555237eea20676a0100ea90f3a3b7e9ec1d5b3a2f9b7cc770"
    sha256 cellar: :any,                 ventura:        "efc46b56ee1d38907889e540d7ad7367340635304206e9ae6288d1051cb38641"
    sha256 cellar: :any,                 monterey:       "e5d0718d774558c0ec6acd882c3da9996445d8e3d43b6d9354e54899d75576d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5ab716f709f6d9866ffe87eaaf887468eb49db92ca8279b2a9cc00148ea9b42"
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
