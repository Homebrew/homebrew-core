class Quantumxx < Formula
  desc "Modern C++ quantum computing library"
  homepage "https://github.com/softwareQinc/qpp"
  url "https://github.com/softwareQinc/qpp/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "094452097e84ab0f743cf27e0b91f4797f041c7924b4794f20153a6efed95883"
  license "MIT"
  head "https://github.com/softwareQinc/qpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c1c17a10188eda3c602b1822d3e98f6289a6b60de6abc5ac309e1e75fc44435"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "pybind11"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--target", "install"
    # The upstream source hard-codes `/opt/homebrew` in their config file.
    inreplace lib/"cmake/qpp/qpp_openmp.cmake", "/opt/homebrew", HOMEBREW_PREFIX
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
