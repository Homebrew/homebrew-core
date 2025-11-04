class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "72c60a0fa6871073a4a458e80947dd75894fa1ff69550c7c77f9f4e695dff7f1"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5c5b7d4076b9832a49d4c046159793b9d5b1d62ae0f8dc728200b01e0cd3be5"
    sha256 cellar: :any,                 arm64_sequoia: "156102c5972d1d22e3bc19b0b4c595eee8d1963d1f70194e2ac41f74a9c05417"
    sha256 cellar: :any,                 arm64_sonoma:  "c4186fe15156691d8acf816dd4542fffd18224efc959d1ef981bac64a8b4a23c"
    sha256 cellar: :any,                 sonoma:        "c1499dc97aaf9c88d5ee82c996e2428d440746fec327baa8a65ca11df6702127"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf7340909bbe6278f23b45704aeabb9b5cec660b30e9fecfa8a55426b9ca019b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f59fd4bf2f47474c2eb922676adc8cf24a2c940b5bc92439df4719e7a5136d9f"
  end

  depends_on "cmake" => :build

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
