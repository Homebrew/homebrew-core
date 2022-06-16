class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v2.0.4.tar.gz"
  sha256 "c8a12cf60f6ce8c0e556f68bd80e7bd9f11f5876e198ed3637da8ccf182eaa24"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b69ccb868a8f06dc6bcbebfcaf1b3dd005a983941253fff7842d1845e63ef37c"
    sha256 cellar: :any,                 arm64_big_sur:  "7dfd01f82fb1b19dbed13fccda45c677f99640335aeb7b0b286664c653ff6289"
    sha256 cellar: :any,                 monterey:       "247da92775194238330ebe32d5e5faf810f12cb9aa4030e3d56a200054bec430"
    sha256 cellar: :any,                 big_sur:        "2bcde7afd6beaaace35bfca1fd872576eedf4e990908f4cf15b939191e7da270"
    sha256 cellar: :any,                 catalina:       "7235cd30c8b09d65cd0a8eaf6a1145e16fcc67711ed42dd7290c72d039afb4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51efb343063b7846fc36d26d57d05ba10537cd033801e2870b507dbfd79d8d47"
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
