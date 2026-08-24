class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.6.8.tar.gz"
  sha256 "18b5368b9ddaafa12c013b0862f32f7ad96c08f95841ebd686e0009b21c48ce2"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9fe57220acf2331700033591d734f545fcac7e1b7a6aad4a920d2b12af2e6843"
    sha256 cellar: :any, arm64_sequoia: "1f587d1f4e297eb2f3da010cbc4930301727ffcdc1eea04852d875f3929739f5"
    sha256 cellar: :any, arm64_sonoma:  "3f4abf19e567c448876de54e2b2f4063dd668890785a0c764e36d6faf69b3e9f"
    sha256 cellar: :any, sonoma:        "793d12f105214cad2e97f88ddab529c1450a5e0b5c2fdb49678949f3a2a3a111"
    sha256 cellar: :any, arm64_linux:   "2ea766ca01fb30df07b266ae2f6edf8d67d6ddb05dd281b923d6d7fb1a576b64"
    sha256 cellar: :any, x86_64_linux:  "ff7dd69e7c18ba558431f593d32f7693b82ac8c04c0f689d80891120475b0f96"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DSIMDJSON_BUILD_STATIC_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.json").write({ name: "Homebrew", isNull: nil }.to_json)
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end
