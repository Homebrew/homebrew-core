class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.3.tar.gz"
  sha256 "77ea1b90b3718aa0c324207cb29418f5bced2354c2e483a9523d98c3460af1ed"

  bottle do
    cellar :any
    sha256 "0ce658deb59e0d2fc5268fbc4f02923770b5be7867ab10e2d2bba339d71bd593" => :mojave
    sha256 "cbcedc236b8ec1dbd389de60327e59fc546cf116cccd5d7d5da786fe52a4e7c0" => :high_sierra
    sha256 "b332f87fbdda1324e819dd9e4c4f388b58e9c19159b97afe92b2992a17add1b9" => :sierra
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
