class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.9.2.tar.gz"
  sha256 "79fbe700f4ac3dd69c4f08275af58399daabd612bca0c0465aea959c60256651"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d848679fe344592687fad8eae52e07deee57dd7d531c346f4ce42fe607c9ce98"
    sha256 cellar: :any,                 arm64_ventura:  "035de549c5da430e3a5928d5af12acc378f156fb1890c06ede56f391a7a7a1e1"
    sha256 cellar: :any,                 arm64_monterey: "578a5d2305f39735ece2e9c5b39dda5214638bc2242ec308e7df883475ec48f4"
    sha256 cellar: :any,                 sonoma:         "df53f1823e05dddf116cf68af7df6109014fc2b475672efc4e23db955ed5aa5f"
    sha256 cellar: :any,                 ventura:        "4c3f8c6a63126e6c11a916c407f27eb40949c5ca5ba59961ecd3f41e06409a07"
    sha256 cellar: :any,                 monterey:       "f8c57c684902f76fdc314c41316eabd1287816d4afee8a00f989a63fda9ba6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4449c81c6b13a327da069baca7df8978de1771e1b64111723a765d707008d680"
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
