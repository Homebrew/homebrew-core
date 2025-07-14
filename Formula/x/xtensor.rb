class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/xtensor-stack/xtensor/archive/refs/tags/0.27.0.tar.gz"
  sha256 "9ca1743048492edfcc841bbe01f58520ff9c595ec587c0e7dc2fc39deeef3e04"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "940cc6cdb9b373184f943e58b6809cbaecac5f1437a506aa3688fa4cbe9c3777"
  end

  depends_on "cmake" => :build
  depends_on "xtl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <iostream>
      #include "xtensor/containers/xarray.hpp"
      #include "xtensor/io/xio.hpp"
      #include "xtensor/views/xview.hpp"

      int main() {
        xt::xarray<double> arr1
          {{11.0, 12.0, 13.0},
           {21.0, 22.0, 23.0},
           {31.0, 32.0, 33.0}};

        xt::xarray<double> arr2
          {100.0, 200.0, 300.0};

        xt::xarray<double> res = xt::view(arr1, 1) + arr2;

        std::cout << res(2) << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++20", "test.cc", "-o", "test", "-I#{include}"
    assert_equal "323", shell_output("./test").chomp
  end
end
