class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.21.7.tar.gz"
  sha256 "03c517c1614fcef667150f436b387626d00c65bdd11c55a5da36e29cf849bfc0"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "81af92bf3fd175267d01bd86971e8503b243939b6dc3c42af2358e99d1fdc49e" => :catalina
    sha256 "e3140dcfceb902a05c95880169ded05d3683d8d7cf68ef25fe750bb52a696a28" => :mojave
    sha256 "e970e18d5536e1b69bc4cc42a50ef963f105d87f34740e4a52dc41310219c776" => :high_sierra
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/xtensor-stack/xtl/archive/0.6.18.tar.gz"
    sha256 "4999013881cc1e1c12941fb9c9ed4a701d09ba83c72b8abac3011793a3a6fee3"
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
