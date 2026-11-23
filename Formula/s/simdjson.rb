class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "5e59df8bd3fa760937e6a2ca68193399c85b52b5042716700b149a734737dced"
  license "Apache-2.0"
  compatibility_version 4
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    manifest_sha256 "b9a50d6cf500188b4d941f25acf6fd04b350501f13112d0547b09ca2ab4b6a92"
    sha256 cellar: :any, arm64_golden_gate: "12edc4108826695c36dcc92c9a2b5a7d09a541cba59abf97237e2cd87f6cb37a"
    sha256 cellar: :any, arm64_tahoe:       "c6049befced71a76a6b3377c0e81485f012212500060ab7ca63166d12880e47c"
    sha256 cellar: :any, arm64_sequoia:     "3693611ead36ab9b716b7809dc775f4e5a773cc235c424d8791b9089f3746d3e"
    sha256 cellar: :any, arm64_linux:       "09620223cfca0f070c9509c3d045718ec9b9df9f7da801ce72fec2cdd9f8dab7"
    sha256 cellar: :any, x86_64_linux:      "581a6c6bc7ae53f192a36dc30492ec5ce10df4c2586f0df9806afc634cf914fc"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
