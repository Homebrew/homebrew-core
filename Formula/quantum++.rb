class Quantumxx < Formula
  desc "Modern C++ quantum computing library"
  homepage "https://github.com/softwareQinc/qpp"
  url "https://github.com/softwareQinc/qpp/archive/v4.3.1.tar.gz"
  sha256 "534133f57b6bb06c39aa3ef868a8eb38f95415ab23e538d9d05307528ba2d159"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce9c2cf36c71e6ce2a3198afc6aabef6b96739942580da579544e5002cadccc5"
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
