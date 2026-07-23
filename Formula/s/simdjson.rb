class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.6.4.tar.gz"
  sha256 "b091107844fe928158c5c2265c20360fff312889ddf7ebc4528a0f0f8f2ff9cd"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78c41aca5e97f628caf04ff851e161e8a08fb8dd0876a6e5919806a639e97228"
    sha256 cellar: :any,                 arm64_sequoia: "00758a0e93afd33308a707d160ebfa345297afe0ceb2fd3a430b32361a140bb8"
    sha256 cellar: :any,                 arm64_sonoma:  "1cf2260d3c03129bb9796036547cb6b344102194cc95e3f4f92db6b25944f2b5"
    sha256 cellar: :any,                 sonoma:        "de7e44e78aa7e0272ecbdbdfe84afdff3beda6f68b24da2c62e5f0f2318b4856"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77fb822a67dc40beebfb3cfdd2dc10ef9d187f6558e16ef5f7d1d5739adadb5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba232718238ed1a0371e1da31a2db8047515a1aba43b309bc9de4a8ff3489268"
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
