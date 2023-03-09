class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.1.5.tar.gz"
  sha256 "5b916be17343324426fc467a4041a30151e481700d60790acfd89716ecc37076"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8984b0f030e1e15cfb4a0aea55249bb1cf259b7b47889f52e6e1c4ec5c2fa8e2"
    sha256 cellar: :any,                 arm64_monterey: "55d9b560bec00f0b3c93d97d8e9ff4edb33f74f58bc266aa6f01fde3d1cd9bce"
    sha256 cellar: :any,                 arm64_big_sur:  "697a0ea321129e068fd3e1e420358a632ea7c8b1863e905a80e7670a899342bd"
    sha256 cellar: :any,                 ventura:        "94347bea12e872a67ddbaefb16df49df59adef50a07dde5f93587e203e00b121"
    sha256 cellar: :any,                 monterey:       "09dfa38ce53abfa3e3eef00a37608a544db669a605944540acba35ad47877d58"
    sha256 cellar: :any,                 big_sur:        "cd363e0b0dd3f7b4afdcf51c653ab9e8628f4edd9819f38016db9142c21c8212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d76767740d1c3a2034c5b98c4f1bdc8a82ea91b02c9af895fbf6931e17cfcbbd"
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
