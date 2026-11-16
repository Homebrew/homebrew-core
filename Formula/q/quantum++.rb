class Quantumxx < Formula
  desc "Modern C++ quantum computing library"
  homepage "https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0208073"
  url "https://github.com/softwareQinc/qpp/archive/refs/tags/v7.1.1.tar.gz"
  sha256 "9122dfee3fa99c307cec758a048ef17ed44a0a2fc9db69f182d6ba96c453897c"
  license "MIT"
  head "https://github.com/softwareQinc/qpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "76b45b86e3065f46f96917225eb9d5580732f69a2db93a43558868eef984fbf9"
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
