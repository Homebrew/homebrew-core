class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "04f7e0381eab0eaad68d031b9438e7843e2f6b138151c1a9fd0fe4cc4bab3250"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8de385ff9b1937535805aec5b8292cd9b38cc3a6cea73525e6bb0500fb1fb8f"
    sha256 cellar: :any,                 arm64_sequoia: "d71a970dbe43100a80e3767a5a9f8aa2ca8546bf612babdf3998a0fc80bd2b1c"
    sha256 cellar: :any,                 arm64_sonoma:  "935fd2858af2988e2c7ab8eb3abd87f75189948f15d1185384617be8349ff528"
    sha256 cellar: :any,                 sonoma:        "1f5d28cc878460e3dcec586c95a2f7894ef7844bb12bc0a50ab2b8e26c2ea23c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ac9deb905468f606ed2f93fa23d051d23fe7aca0ec8066310ef5674b5828cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9aef4e8dabcc908aff54ac8e46d62da2dac779cd2648333a97bbe0b67c847d7"
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
