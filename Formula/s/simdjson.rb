class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.6.11.tar.gz"
  sha256 "61d948fc24f0d793829ad658058e7597d064988a89b4607ea02e401a82df98ff"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "87075de6c5f78a6603441b1961b11e0ee3e58f4db63bf1b77d7e07232db481c4"
    sha256 cellar: :any, arm64_tahoe:       "f1c46af72c3a884dea4645b1908cb1e52cdc967173a4f92ad28d81a1774bd7ba"
    sha256 cellar: :any, arm64_sequoia:     "3d99a177ab9a3e6be0bc39fab7723dc0fa96b0cb0f6fb27ee9ee6cc3ec0551bb"
    sha256 cellar: :any, arm64_sonoma:      "a150e8d93f10e371e8af98100de9b1adaedab8c3caf7f4dc1b8cdab008aa18f9"
    sha256 cellar: :any, arm64_linux:       "b1fb32e3b1239b2a689dfe48858669c3ac011d55b353cf423ed8f7ec24b7abda"
    sha256 cellar: :any, x86_64_linux:      "07bc2cac4a896e0235b46a36fc2fb1cc65824d9bb6962238d18c63ce68525abf"
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
