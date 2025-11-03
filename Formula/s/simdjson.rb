class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "cf294f624bab25d6e48f2c5380192f839055a7c0e82a77b454f5fcefdb02d07f"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3745d0b910d0ca02645c0ce6e401db9f86b737b28f0be1b3d3f26759efc659a7"
    sha256 cellar: :any,                 arm64_sequoia: "b523f1c220781cd1b0c7f4c5263c29d451fb640c650642958f8e5551ff882942"
    sha256 cellar: :any,                 arm64_sonoma:  "22ca7c84650ef77d95c3594b007f5f470a03018932607587cc0f96814690983d"
    sha256 cellar: :any,                 sonoma:        "345d998ee82a446340d930bd3b80b1e32937b0fe9766daa4a06b856ad80ecdeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcaf1caee9c0480f9068fb61abce607c22543ad75d3870faa69fdd0c889b50f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94faa92736d1afda75d551b1830e12913f354af3d09bcd28c163ab7edb103022"
  end

  depends_on "cmake" => :build

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
