class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "1712f1b81e59d1c4b9dfb6a74a66a101ec23ab2d5db40cccc0ee5c90afc69f2c"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f11813cc7cf67077b88f16618b285eb29cbbd96c216f37ec4c94a37380ad4974"
    sha256 cellar: :any,                 arm64_sequoia: "26dbe5889ff0a478d17b6f4422656f22f972852d5bbc19e876114903f714a779"
    sha256 cellar: :any,                 arm64_sonoma:  "7a8fe01c0997e56feab2d3443d75f1a1a040b70f0fc13648c8fb7ebce8625450"
    sha256 cellar: :any,                 sonoma:        "3dbe1cc3f25346aa81fbe12584689fd3729b2473eef4394c5a0a9a95a884745a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "deaad91f61f8f5b628f915b5960b4d0726b0b9f5462a41c535534d6d1a486fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c200af0f5e4106ce732f4a7ef806a2f189e7d2de3cc7f973e4ea7f59a20300f"
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
