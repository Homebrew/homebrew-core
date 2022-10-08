class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v3.0.0.tar.gz"
  sha256 "e6dd4bfaad2fd9599e6a026476db39a3bb9529436d3508ac3ae643bc663526c5"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ffea489affbc2d67cfb77d8690eee7bb30e106f606d68aed22ca84213685f554"
    sha256 cellar: :any,                 arm64_big_sur:  "78e73f3fc2f814f9a636f7a1d9aed51fbcb5f279087958959005926710b0895b"
    sha256 cellar: :any,                 monterey:       "d800f94ed642d54c0a27a0b0c4b4762e80e2f678f9055b16afac138e25157a15"
    sha256 cellar: :any,                 big_sur:        "a2760e96f267af450bd40ff8ed550c402f7a65bb759c46d7e09524eefb21182e"
    sha256 cellar: :any,                 catalina:       "15c1984b43ecc384239cf2f0dbb41b7fbc797e7d3adf8df97a71e5689f2876ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d999f4424cdd270d9015ae7d46dd134a99f91f3d2c2654eacc9ef9deea8c56e"
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
