class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.23.0.tar.gz"
  sha256 "578c89a2e7f1f5aa03d8098882ecef60233d3b8f4363d5caf35624989a24ddbf"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "e402b8dfd49888418be330bc6b504fab08cb6454852252c7894c6a017b14085c" => :big_sur
    sha256 "74dae1f7b0caf3350e8ef37622e4925bbf12a8528d406025f6e7d94b52f5a330" => :arm64_big_sur
    sha256 "d9fdeda4074c25c20069315de7217a29a4368aad236773b2b926af1bedce3767" => :catalina
    sha256 "316c971431dee94a15c7305986bf368007ab557e124a0610dad265b43554e695" => :mojave
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/xtensor-stack/xtl/archive/0.7.0.tar.gz"
    sha256 "7f3d75bd3c175e3f564d0c7a43274a01ebf297659cf2f5bdd6c455992c4ad887"
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
