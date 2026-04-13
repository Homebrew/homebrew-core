class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.6.1.tar.gz"
  sha256 "372db94d6c4cd3ea2ff9fd9e68a9aa173436752a643580f3078bebcf612e01fa"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ff00f35f54b3512111b280def788bfda767e60ee85285729e6f8154ab193f3a"
    sha256 cellar: :any,                 arm64_sequoia: "79638065124c814b210c54c08b8167a91fb74948bf78b663acf7ad3557ef8204"
    sha256 cellar: :any,                 arm64_sonoma:  "e23eca62fe51e5b5676d0fc0c40fda1659d6e7c797b14668a7bcf2243c113870"
    sha256 cellar: :any,                 sonoma:        "154229d813e052b2157b29125110f46e93981d72d0ac6672a5dcae18b05b53f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de20291f6cd8a5a86fe444c9f1728162abfc078f05638c9ea383efd9a1d518e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559297eb2f81079ea74ff3ce9be9f9b8dfc51201d94a11a875b6bbedb000f92a"
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
