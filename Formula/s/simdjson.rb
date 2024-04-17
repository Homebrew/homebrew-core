class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "a4b6e7cd83176e0ccb107ce38521da40a8df41c2d3c90566f2a0af05b0cd05c4"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "833e521d3e72db65be9b3d7d3568aaf6b4dc0fc2af5ce0439138c74cfc65fc82"
    sha256 cellar: :any,                 arm64_ventura:  "33e2e0d23373fdb80170661b3f64204fab7e9f0350512c76d611f51808fcbbaf"
    sha256 cellar: :any,                 arm64_monterey: "a5f6bf7e43692bc9d8a7a0a04f2ffe65d4a719256b85172cd13c20c801af15ed"
    sha256 cellar: :any,                 sonoma:         "eb463654ef824bd4b842e16a691ce9833b7ea92c2a3ebc1efe1f4ef69374aa99"
    sha256 cellar: :any,                 ventura:        "182ddca7aa6f43f59546536e897261dcbc355720baf84292ba32dcd145736ebf"
    sha256 cellar: :any,                 monterey:       "ee412813da567c7646c9870102acb009dad7cc41d508b1202de29393d809ed46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88bc133323dcadd7889b8813b118e0b8b76c55886857596352fe284320b31eb8"
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
