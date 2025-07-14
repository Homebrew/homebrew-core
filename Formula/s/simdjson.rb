class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "07a1bb3587aac18fd6a10a83fe4ab09f1100ab39f0cb73baea1317826b9f9e0d"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2d66e98360e79ddc9c6659aea66532e472b31186f83a9d6efe240065833ef1a0"
    sha256 cellar: :any,                 arm64_sonoma:  "09d15daf7902bf3d9acaeb330213d8989ec42f6b47d18774805efabc8dcec563"
    sha256 cellar: :any,                 arm64_ventura: "9f4c5211b7b231e77b6e582dfee0453b1125cecad9e5b0aaa79dab1bcce1961a"
    sha256 cellar: :any,                 sonoma:        "2d2a463a26509e2b0fb17195ac08f6d64b1f3fd05d518360ae971d79d0fdf69d"
    sha256 cellar: :any,                 ventura:       "0630a2e93b646ae610a63fcc362d444d5c28c43e1197c7fbcdcef3d128f93790"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "263c95f269c2bd4426e68ede98f171e0bce930258f40752bdd79dbdbae4c4694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ee079674bcc8c6c27dd8b812845eb9cacf84e0a8d406a068bed56a50b9dc0e6"
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
