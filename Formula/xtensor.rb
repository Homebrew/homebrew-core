class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.17.4.tar.gz"
  sha256 "45bb52d9ddcbea74ddd0b9f57cd6a733a6b52d8545c1164294e6dc70e9f64211"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cf46343ce00bd1e91eaa3349828ba53f3be45e3af36bb27d75e7a3bc17b4200" => :mojave
    sha256 "e9a6333361d5c12949ff10dded248d1c100ca3a8d6b9c3b9c30b8720c1c209a8" => :high_sierra
    sha256 "e9a6333361d5c12949ff10dded248d1c100ca3a8d6b9c3b9c30b8720c1c209a8" => :sierra
    sha256 "e9a6333361d5c12949ff10dded248d1c100ca3a8d6b9c3b9c30b8720c1c209a8" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx14

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.16.tar.gz"
    sha256 "480b1b9afd810838f8635beea9056f0591a0b4fd4181abaf32c698dfd01bf0ea"
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
