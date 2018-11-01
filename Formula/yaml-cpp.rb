class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.2.tar.gz"
  sha256 "e4d8560e163c3d875fd5d9e5542b5fd5bec810febdcba61481fe5fc4e6b1fd05"

  bottle do
    cellar :any
    sha256 "ad5862fe71b309d1b37f9cda29e969e803b3c3ef93432b38faf68c4b7b5cf4f3" => :mojave
    sha256 "5e1d0907d3cb39861ff36476f8cabb78d9bdf4a9b228cd860502b03b280c226d" => :high_sierra
    sha256 "d081b409a0e7c60fc5c4d2c965b63fc0f0c7f3b1e36f61274719982ac5799b09" => :sierra
    sha256 "5ad764dbd25373bc0bd68b213c611650694fe69f36c90fcd746aa90bc876e8f3" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

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
