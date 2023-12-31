class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "afd8201cfb1abe927737d876441bb1f21730a9ee6078a1b8c6174e6463981fa3"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "77e47d1a5ba332a3c31f597cc5037e6e43f133d1c4e16c1505159185110387bd"
    sha256 cellar: :any,                 arm64_ventura:  "2952d1d82d64698d80bf5d3e4e1681c61d7070ea35cc96125550f12e4096d2d8"
    sha256 cellar: :any,                 arm64_monterey: "0f9d3ef7a045f1c76acba381a33d677b7c618b0b25b195e0c2db483ca2656e5f"
    sha256 cellar: :any,                 sonoma:         "a96659f5787b4628e31173a47e1218478f6235f637ea9cf96d9b84e1669992d9"
    sha256 cellar: :any,                 ventura:        "b1a94e41aa893582a37a5253f6d4c00b551800b7bbb6d17667211c9d0c0bdab1"
    sha256 cellar: :any,                 monterey:       "3d11c2998642ce49d362541cf2c379235786918dd0357fd21208eaca171341c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f71a4044787d17bc3642bab9bbaf6c6395bf9eb5d10159f6cff43ccdef0126c"
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
