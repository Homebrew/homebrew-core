class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.16.4.tar.gz"
  sha256 "9a0d9ec254383c1721473fb391e10f082eeceec4d0a7bf29fce9356c68949e74"

  bottle do
    cellar :any_skip_relocation
    sha256 "d22ee620c3ee1d0582f353bd323474c7263ac70d3606672fbf9b411295b5c565" => :high_sierra
    sha256 "d22ee620c3ee1d0582f353bd323474c7263ac70d3606672fbf9b411295b5c565" => :sierra
    sha256 "d22ee620c3ee1d0582f353bd323474c7263ac70d3606672fbf9b411295b5c565" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.12.tar.gz"
    sha256 "e1259dbe482c5c8197b7a8d02ac5027ad716b2ff52503e0232e4efaeb2769e67"
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
