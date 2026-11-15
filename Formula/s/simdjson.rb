class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "499176afd4b32fbe6f65551ef573b880407280072e1c19e22df0b45da58cdf64"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c51faa51fe676376cddb2a4f824e36bf93c05e287462a15428c3a7048be0928b"
    sha256 cellar: :any, arm64_tahoe:       "35f74ec4be7df5e6095c295c2d4494d8d4dc0e3fd016b7c88ccae1a1b4fd80f4"
    sha256 cellar: :any, arm64_sequoia:     "d8df05622e29b5399fd4724ac08e9a969444bcab93908aa1620c1f6c5212127f"
    sha256 cellar: :any, arm64_linux:       "536149e525765f5a45aa08b73035d1c3dce2d40d689285c8f6a5f8c8b106594e"
    sha256 cellar: :any, x86_64_linux:      "8ed30d39e2a12ba6d658ef42c4f741431c63d31f175bf9f39f49418ac5f8fa81"
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
