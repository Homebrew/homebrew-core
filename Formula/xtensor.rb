class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.13.2.tar.gz"
  sha256 "e257d2dc33138a92948fe1ab6458d7c92c3cf4ab3fd82647a6c2211580c5a25d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f22087dbcb420b84447bbcb967ec0ea096d1a5fd27a8af8033193ca8a7cc884e" => :high_sierra
    sha256 "f22087dbcb420b84447bbcb967ec0ea096d1a5fd27a8af8033193ca8a7cc884e" => :sierra
    sha256 "f22087dbcb420b84447bbcb967ec0ea096d1a5fd27a8af8033193ca8a7cc884e" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.3.4.tar.gz"
    sha256 "618536c3998091b0bdd7f8202e8bec9c34e82409c8ee0ea179a2759bdea426e2"
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
