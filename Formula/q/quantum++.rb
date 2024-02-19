class Quantumxx < Formula
  desc "Modern C++ quantum computing library"
  homepage "https://github.com/softwareQinc/qpp"
  url "https://github.com/softwareQinc/qpp/archive/refs/tags/v5.0.tar.gz"
  sha256 "cbff36004a94d16296493460aa977f1274cc23597f4ba72386ece15ae95a8e8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "52612ad172908ab0b88516f2f33b8c1b5b2e360d1174ce544611ef31bba144e6"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.15)
      project(qpp_test)
      set(CMAKE_CXX_STANDARD 17)

      find_package(qpp REQUIRED)
      add_executable(qpp_test qpp_test.cpp)
      target_link_libraries(qpp_test PUBLIC ${QPP_LINK_DEPS} libqpp)
    EOS
    (testpath/"qpp_test.cpp").write <<~EOS
      #include <iostream>
      #include <qpp/qpp.h>

      int main() {
          using namespace qpp;
          std::cout << disp(transpose(0_ket)) << std::endl;
      }
    EOS
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_equal "1  0", shell_output("./build/qpp_test").chomp
  end
end
