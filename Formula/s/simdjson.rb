class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "e28e3f46f0012d405b67de6c0a75e8d8c9a612b0548cb59687822337d73ca78b"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2361de669985c4f9921fd321e2659a4cb4a3e931563501e0b2674d25deb6334e"
    sha256 cellar: :any,                 arm64_ventura:  "14340b0d485a04f5b9597cf16107f0c516565a33e3d5439c60fc67f2d63c77c9"
    sha256 cellar: :any,                 arm64_monterey: "27dcf506584491159a879c800e6149ec5f5adac97f91f3c75156bcab74c827cb"
    sha256 cellar: :any,                 sonoma:         "9bc113232e1bf999a7791662141395039136938d59f84abda54c6e260c14a4e3"
    sha256 cellar: :any,                 ventura:        "6580f435baf46439cb16dffe5b970200ee114e1bc1b8b93e6427c6163ea2a181"
    sha256 cellar: :any,                 monterey:       "eebaa32ff1f2cf5b9fbf2fe11f429442842180ad673380ed9dc5dc3a7b806d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c0b6e60cfa8ad2deed8df5da3dcebd23f961843e48657c89ef16f13c356ce4d"
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
