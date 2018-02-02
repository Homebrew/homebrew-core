class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.1.tar.gz"
  sha256 "25ec37e6d82ab8c485926d69a5567741c7263515f8631e5dcb3fb4708e6b0d0d"

  bottle do
    cellar :any
    sha256 "78e12dcdd830f2d8b0efcc03e788774ba2ee91e4399addb339db11c5d7a41220" => :high_sierra
    sha256 "7c6bd9e166e104af6ef5b42058ca3f3e907b565aa035f4fd3a0f7a8dcd13429d" => :sierra
    sha256 "2ece56723e6c90baa1474115ed40445aa72a71787ff78f721111f5791ab1567b" => :el_capitan
  end

  option "with-static-lib", "Build a static library"

  depends_on "cmake" => :build

  needs :cxx11

  def install
    args = std_cmake_args
    if build.with? "static-lib"
      args << "-DBUILD_SHARED_LIBS=OFF"
    else
      args << "-DBUILD_SHARED_LIBS=ON"
    end

    system "cmake", ".", *args
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
