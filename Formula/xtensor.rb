class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.20.8.tar.gz"
  sha256 "5421aede8971342adb97becea4edfb9a4b05bf9ebf64b0146003998ee4153383"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd91f1e093dd83c47e6857e3762f374b35a8f210aacdc7b9134ca5c4f7fb81b3" => :mojave
    sha256 "cd91f1e093dd83c47e6857e3762f374b35a8f210aacdc7b9134ca5c4f7fb81b3" => :high_sierra
    sha256 "ef3962344fd57f9b16ea8676b148a07ad355e55cb3c2d8ff0c9458f911062fad" => :sierra
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.6.5.tar.gz"
    sha256 "337cd7e9245fedbd3028d965ce583619135188ee7494c750d38c794050eb74ec"
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
