class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "1e8f881cb2c0f626c56cd3665832f1e97b9d4ffc648ad9e1067c134862bba060"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6caaeb2dccf5953efd630bfa19d5f6d12ec229bb29b4f10a405a8c9513b4ba25"
    sha256 cellar: :any,                 arm64_sonoma:   "c10d30c3b052deb786fba4e0b2e1e14dbb0640826b82e7c6482e7191774c0402"
    sha256 cellar: :any,                 arm64_ventura:  "3e206709db5ef6cb0839376e0deff999587311b60204c9390c6de152ab7db360"
    sha256 cellar: :any,                 arm64_monterey: "543289d72912bf50c40ca393e4f87065be1472d1c19e4b1ab6bed02093343f3a"
    sha256 cellar: :any,                 sonoma:         "6bc43fd1d128554706c37b37d800a6995dbc80e7d26b86786a477fb5d7225397"
    sha256 cellar: :any,                 ventura:        "17204785c149399ce66c1f03d3ffc275f7032b3a342f54811ccc56c861c48928"
    sha256 cellar: :any,                 monterey:       "3141a0a0a6aaa0ad3af1d144360a315a3d4fef7cb50d1480db9f0687c999f936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f97e203d980764ece55c69cebb8ebf750432bd0b1918410f08b83bd252805ee2"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

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
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end
