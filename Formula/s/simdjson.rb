class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.6.3.tar.gz"
  sha256 "bde0c42f43899c4c5c48be826c09abd22500ed537b89f16b3cced5eec477c263"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6395a67854165f61766f83c9bbd7bac070ae6bfade7a21dcea75e662bb128577"
    sha256 cellar: :any,                 arm64_sequoia: "7b5bc0b0b838a30573b960f17fb00716c9cc8db0608a478308a5ac9150c68074"
    sha256 cellar: :any,                 arm64_sonoma:  "9bc37b68c6793fae8923f28559834ecfd33953063771417105d016eb2121b86e"
    sha256 cellar: :any,                 sonoma:        "6658f5809ba425add205d79c1ac9efd25cc537d2ee52a7e1b6ed8425e0010a38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8549479a28fadff12d50783cd6b4c2c332370a4730d8f2c94689255b4a2127b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bb9cdae11adef917e43c34579c6da20509c90549621d3a24030a3ceaedac224"
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
