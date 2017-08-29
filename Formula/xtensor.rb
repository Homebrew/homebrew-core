class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.10.11.tar.gz"
  sha256 "ece005f5ebcbc1e49d84bce689c739f0fb3d9f614383d297ad0f5bb88788d381"

  bottle do
    cellar :any_skip_relocation
    sha256 "24b76891de73a430bcbca8fd692e5c8ab524bf1339771fb9d2292f4062fa3b54" => :sierra
    sha256 "24b76891de73a430bcbca8fd692e5c8ab524bf1339771fb9d2292f4062fa3b54" => :el_capitan
    sha256 "24b76891de73a430bcbca8fd692e5c8ab524bf1339771fb9d2292f4062fa3b54" => :yosemite
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
