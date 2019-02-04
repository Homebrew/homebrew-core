class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.19.3.tar.gz"
  sha256 "51510735809ee7ab5312197b303f117167667aacb9254605f272b08efa8880f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc74f983037ca4a758d78dbde45f15c23a23bef89121445e9d34e333da0ba85d" => :mojave
    sha256 "12699f58693e800205659da72af462965efb3d305823df255b23d9b7e01bc7fb" => :high_sierra
    sha256 "12699f58693e800205659da72af462965efb3d305823df255b23d9b7e01bc7fb" => :sierra
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.5.3.tar.gz"
    sha256 "dd109b7d042fb1ef4619b72aa69b7f1ced51a3927d422b09dd77e7e3cb5dfb1a"
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
