class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "c4f663d5c8f8d8829d9f771188c7e12a2f24c3df1c7c02b59a5ee7996b7838ec"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b991ad995e684b5d21929d3d4966288f51dc7a33d7298936d6d9d9f2e14b214f"
    sha256 cellar: :any,                 arm64_monterey: "32a30a662c4892011ddf862c129ff9245225ff9e4b013e6cb7e144b4ff185953"
    sha256 cellar: :any,                 arm64_big_sur:  "430e6074cbb508e57aba6559fac4570fa83eec65e6a56c70df753edac4b17fb0"
    sha256 cellar: :any,                 ventura:        "1f80c77a29178311e128ba024b091c85d489fb868184cb67c1b9248348d672e7"
    sha256 cellar: :any,                 monterey:       "48a85e860fbe4217862ccdb5f24a1ea176530c322f09ff7f2a0273f55b09c6ae"
    sha256 cellar: :any,                 big_sur:        "3dcf56b6959b38b42b09eb3f5cc8f0915506cb1508a878a99e1a50e002eb3b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc1f7a8bef7b50691a75be1438b3ac98f9a0b4dcaac09ab3ba5346718c9fa23b"
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
