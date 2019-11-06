class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.3.tar.gz"
  sha256 "77ea1b90b3718aa0c324207cb29418f5bced2354c2e483a9523d98c3460af1ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "e359e13c2fc0564c7500572af0a711d0a9f8b6655f0ab9d214d644ccc855ff68" => :catalina
    sha256 "1e43334e4896703dda18ca52e76b4ec8bf850fb253d2553f7a9598b426d81773" => :mojave
    sha256 "b4b5fc6d5d29494aa10d9ac75de1514afeda044ef736c5b1bc7953d1ad7162ca" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
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
