class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.3.tar.gz"
  sha256 "77ea1b90b3718aa0c324207cb29418f5bced2354c2e483a9523d98c3460af1ed"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d766bd5e1344fd0b7f72b00c26c5d0be07c7ac3f7153494c2d1b5fd09cd98610"
    sha256 cellar: :any,                 arm64_big_sur:  "3ef6d98fb044cfbb307037287e6c14914f28afc725c964998f894cd8b619ac15"
    sha256 cellar: :any,                 monterey:       "462c7a68900af6262d60785d9c4bed2e1d5e285462c5cfa4e8b08c78a855fd62"
    sha256 cellar: :any,                 big_sur:        "a4cd13489c2e397883162dad15f3a08adb434601ba2dd84d124c141f64f719fc"
    sha256 cellar: :any,                 catalina:       "7cb356c020e5e1f2a32d5b2721516b9079cc4518556a0344fd498df6abe04731"
    sha256 cellar: :any,                 mojave:         "ab76f2d444f7948c73f102588d079e4a3a0c758974f42cec1bffa31e80ca7bff"
    sha256 cellar: :any,                 high_sierra:    "824351b703802346eeb47a3a0acdbf438327cc1cb77ef4a342493a938574c6d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da42c4363df3e48044876fb7f37f87da3e2def622b0d7cb99412ba8ba70729a5"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DYAML_BUILD_SHARED_LIBS=ON",
                                          "-DYAML_CPP_BUILD_TESTS=OFF"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <yaml-cpp/yaml.h>
      int main() {
        YAML::Node node  = YAML::Load("[0, 0, 0]");
        node[0] = 1;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lyaml-cpp", "-o", "test"
    system "./test"
  end
end
