class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.17.1.tar.gz"
  sha256 "4c7df152ec712c581dac448c90918a6d1c659959cb59c079cb4ee2da1425ac01"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ec520599895a76a101ea2e79e93d630a9b68c2f77624ada34e3511caa63f548" => :high_sierra
    sha256 "8ec520599895a76a101ea2e79e93d630a9b68c2f77624ada34e3511caa63f548" => :sierra
    sha256 "8ec520599895a76a101ea2e79e93d630a9b68c2f77624ada34e3511caa63f548" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx14

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.14.tar.gz"
    sha256 "f32390060315a7a941d9601ea1f0200c723e21313bd034f36dd5aae52b7a58c8"
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
