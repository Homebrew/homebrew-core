class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "1e5e82f0a34c331c1b0d0c21609791bfe6d6849edfc24983fc241626b433e1c3"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d10fbcc3b40ac7226ca862c0f22ffeca1a301c4fc0859c56fa3c5cfb24a2e63d"
    sha256 cellar: :any,                 arm64_sonoma:  "55dd00ea90201ebb5b4a525ebbfd3904c8cb34a8db896fa5793a277bfaa3c2f5"
    sha256 cellar: :any,                 arm64_ventura: "897cae070494a629df5c9e645cac605d0626b7ab6d0df75ccf11072d1b1f47ac"
    sha256 cellar: :any,                 sonoma:        "243ff4c80089feaa5301a0b05ec7b800d50f3016c57748f72561da1eb8a12258"
    sha256 cellar: :any,                 ventura:       "0b765b4748323b82bc37314e6ef16a8daf6ccdec31fffaf99f9e16a106c0a024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee9ed786bc7a5742e1b03be37cce1fd5067533e19bfd95121c4d1e86cbc2121b"
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
