class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "d669fa399613c20bbf7705f057a72984331b223cd5e8d20666ef063dbf97f3e6"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2524043d1d666933592be91aa5b49b465e49e7839ca46b7f1b46f328da54720c"
    sha256 cellar: :any, arm64_tahoe:       "815b127045b034116907aad0e88edff6719168fd3d6351a9832392f96a13b0f0"
    sha256 cellar: :any, arm64_sequoia:     "c9b1f4a0f4dae44ffc0b3cf914e7b2f2d9a071c94e0e39808d178c8bacb1f4d1"
    sha256 cellar: :any, arm64_linux:       "c0e255fc760513a5d8554072af049e2601f5d29dfeb97941bd673420b086461d"
    sha256 cellar: :any, x86_64_linux:      "5bcd4587e9cfba7e1123587b38b14117ebf3101b1780a3ed1378bad2780b1571"
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
