class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.11.2.tar.gz"
  sha256 "2a4c5e8f0427f1f244dcfc569c7a169ffe3c4904ff4c10858e270c175c8e09c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed836f3ec508d767544693d548ec2d694352cf97d35d21bd65a0532988d365f0" => :high_sierra
    sha256 "ed836f3ec508d767544693d548ec2d694352cf97d35d21bd65a0532988d365f0" => :sierra
    sha256 "ed836f3ec508d767544693d548ec2d694352cf97d35d21bd65a0532988d365f0" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
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
