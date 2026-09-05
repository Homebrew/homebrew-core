class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.6.10.tar.gz"
  sha256 "1d560f233ff4a29eae0eaa8b4138bfaa72ca86714a12da6a85654812581e8926"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6577776b4300e458f13a1ab88217e2330584a7ba993fa3232c659981cde3991a"
    sha256 cellar: :any, arm64_sequoia: "e80d59a834e892ca00ff79a770847c2a65ec3b8ab3c84373585008d22146b7ba"
    sha256 cellar: :any, arm64_sonoma:  "43fc9beaaa0ee77aaa3ef3aad472189aa393fd93f0aac79359ebe6e1f932cb99"
    sha256 cellar: :any, arm64_linux:   "0b3b6736314e31c74cc9c9563f68d4ef4c78f8278e7b4a96be45e798b5345322"
    sha256 cellar: :any, x86_64_linux:  "395a67c7ce6b744445eb2d7818083c5c4552016ea7556bb1411cf651a2eb73ca"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
