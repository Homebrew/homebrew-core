class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.3.tar.gz"
  sha256 "77ea1b90b3718aa0c324207cb29418f5bced2354c2e483a9523d98c3460af1ed"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "7cb356c020e5e1f2a32d5b2721516b9079cc4518556a0344fd498df6abe04731" => :catalina
    sha256 "ab76f2d444f7948c73f102588d079e4a3a0c758974f42cec1bffa31e80ca7bff" => :mojave
    sha256 "824351b703802346eeb47a3a0acdbf438327cc1cb77ef4a342493a938574c6d6" => :high_sierra
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
