class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.17.3.tar.gz"
  sha256 "6e337012c1cff2d61cba922cb5fc3119dcf4ccca1ad71b9b29ab0f55ce8947f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9a6333361d5c12949ff10dded248d1c100ca3a8d6b9c3b9c30b8720c1c209a8" => :high_sierra
    sha256 "e9a6333361d5c12949ff10dded248d1c100ca3a8d6b9c3b9c30b8720c1c209a8" => :sierra
    sha256 "e9a6333361d5c12949ff10dded248d1c100ca3a8d6b9c3b9c30b8720c1c209a8" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx14

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.15.tar.gz"
    sha256 "550ca5ca2ae7fedec6421b7545d592f4474bcd15bb9dec49c644f17b547b9ff6"
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
