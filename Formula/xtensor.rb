class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.23.1.tar.gz"
  sha256 "b9bceea49db240ab64eede3776d0103bb0503d9d1f3ce5b90b0f06a0d8ac5f08"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d640c7bf1f02fc233313aeba9eb5b60d168dc2ee9858f79f563397a777f7230"
    sha256 cellar: :any_skip_relocation, big_sur:       "96aba4540d00b3f4b980cf3aceb97469c1a6fafbe524c295d009ae31da2d9097"
    sha256 cellar: :any_skip_relocation, catalina:      "79b45fb93359f9ecd3f3f1db535d0727c514962494b99b4a81c28e747ac87107"
    sha256 cellar: :any_skip_relocation, mojave:        "537ca6fd32dc25862fb759cd2c2003146c64cd5bdac0657dd6566eda776907be"
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
