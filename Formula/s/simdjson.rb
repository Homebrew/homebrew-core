class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "3efae22cb41f83299fe0b2e8a187af543d3dda93abbb910586f897df670f9eaa"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "f795bf538e72393be5dc71b287eb935fdeb96848d41a2f76e6e7eb52bde329e7"
    sha256 cellar: :any,                 arm64_sequoia: "cc590dd3b5065fb3a50889f6c633072ec0749763c4d72da0ac30b72967ca8f78"
    sha256 cellar: :any,                 arm64_sonoma:  "d9bab2feda60db9a941560188e6fc6c15b85d4fb875f1c3ebdeed66a2566de6d"
    sha256 cellar: :any,                 sonoma:        "11d3b54655c2d5ba1a574c397d30092eb5e2dfc7399afed957c7518e7b2006db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc880cf20b6e26281366a767b6c4fbd4638016afd8426552e016b9b07bbd6ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "306ef11dba7b89c066190ba358ef392f154d98f8339ba7d6a1168d7f6c7deebe"
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
