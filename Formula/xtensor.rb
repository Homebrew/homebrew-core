class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.23.3.tar.gz"
  sha256 "97c43372b6bd1634b6d647a4b318fae541d0c305bac9ec299d3d1bd42790d1f2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "690be77445483e63745926199b2503f527ce17bbb6e47138c74a3ff17d5396e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f9c474e0e394bd3cb083b5c72417c454817ff9a8fb425b14c4f8d0bbc059c92"
    sha256 cellar: :any_skip_relocation, catalina:      "0868f7846528bcddacfb6dea12e8dc8dc0c9ecf26373caa40a5a3209afa1ad88"
    sha256 cellar: :any_skip_relocation, mojave:        "c4b47cbd1b680cfc45473b0931958b38af9f575befb7aab4eb86d732a3683e95"
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
