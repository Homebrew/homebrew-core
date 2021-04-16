class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.23.5.tar.gz"
  sha256 "0811011e448628f0dfa6ebb5e3f76dc7bf6a15ee65ea9c5a277b12ea976d35bc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e81ac3906bfb5dab9de687fcbc25b2c55a5bd514f3d45e7863191cdbf0bbe8b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ca378965e78b03e8a16b3949675abdb100ad82bf14f4413edd9d847bfdb763a"
    sha256 cellar: :any_skip_relocation, catalina:      "b1116d7f4b37123344cb07cc91d8e4d64d8cfdb7c8eb7548aabf8b679e52e6c3"
    sha256 cellar: :any_skip_relocation, mojave:        "1aafbc4e728019cd20dba3e9541731d085eb77cf2a4a8c2531d261a9f157418e"
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/xtensor-stack/xtl/archive/0.7.2.tar.gz"
    sha256 "95c221bdc6eaba592878090916383e5b9390a076828552256693d5d97f78357c"
  end

  def install
    resource("xtl").stage do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end

    system "cmake", ".", "-Dxtl_DIR=#{lib}/cmake/xtl", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include "xtensor/xarray.hpp"
      #include "xtensor/xio.hpp"
      #include "xtensor/xview.hpp"

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
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-o", "test", "-I#{include}"
    assert_equal "323", shell_output("./test").chomp
  end
end
