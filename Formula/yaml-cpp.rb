class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.2.tar.gz"
  sha256 "e4d8560e163c3d875fd5d9e5542b5fd5bec810febdcba61481fe5fc4e6b1fd05"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "0110c3434c6af9ddd0e36cfe2b875724edc221081a3c28437d827c8a1a2e83e1" => :mojave
    sha256 "2479b905895f0877694a510343a411cd3239d190141c02854a193324bc47ece1" => :high_sierra
    sha256 "a0e866bdf04718de53be3525bfc6f12b075a7613fceca1e828f02df054cae8c4" => :sierra
  end

  depends_on "cmake" => :build

  # Upstream commit from Sep 3 2018 "Improvements to CMake buildsystem"
  # which fixes the unexpected installation of Google Test.
  # See https://github.com/jbeder/yaml-cpp/issues/539
  patch do
    url "https://github.com/jbeder/yaml-cpp/commit/5e79f5eed3d86125468681116e92814d2cf40067.patch?full_index=1"
    sha256 "52da989f0dcaca68ae9ee6334155954639506e16cbe3b9bd007dace9e171e4bd"
  end

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
