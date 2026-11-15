class Quantumxx < Formula
  desc "Modern C++ quantum computing library"
  homepage "https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0208073"
  url "https://github.com/softwareQinc/qpp/archive/refs/tags/v7.1.0.tar.gz"
  sha256 "b133d9e683d7a2e343a793d850e660c4926be738e63594b94a90f2be7fa8c98a"
  license "MIT"
  head "https://github.com/softwareQinc/qpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c114651134bfb8e648f6a430cff3343f003c0e9388a606433bcae402216d384"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "pybind11"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.20)
      project(qpp_test LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD_REQUIRED ON)
      set(CMAKE_CXX_STANDARD 17)

      find_package(qpp REQUIRED)
      add_executable(qpp_test qpp_test.cpp)
      target_link_libraries(qpp_test PRIVATE qpp::qpp)
    CMAKE
    (testpath/"qpp_test.cpp").write <<~CPP
      #include <iostream>
      #include <qpp/qpp.hpp>

      int main() {
          using namespace qpp;
          std::cout << disp(transpose(0_ket)) << std::endl;
      }
    CPP
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_equal "1  0", shell_output("./build/qpp_test").chomp
  end
end
