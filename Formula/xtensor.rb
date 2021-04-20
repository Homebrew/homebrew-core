class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.23.7.tar.gz"
  sha256 "3c45c2fe18896e5c4299b9d0e51515a965ef12d6d70c05788db8962908b61655"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c2c42340b6a5629340649d20f2e466cfcf282551c92f0df5eed7d6223c7870f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "65e9d1c79874ec11d832444172d5b0d4d5aae5271e25b67ff2b4a1cb992c8474"
    sha256 cellar: :any_skip_relocation, catalina:      "65e9d1c79874ec11d832444172d5b0d4d5aae5271e25b67ff2b4a1cb992c8474"
    sha256 cellar: :any_skip_relocation, mojave:        "9aa0d2466527e51d0f68b033b265191f90e1f5cad5b13986f83361995078a9ad"
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
