class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.19.3.tar.gz"
  sha256 "51510735809ee7ab5312197b303f117167667aacb9254605f272b08efa8880f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd6e8d6700c8b76642b73e17bb8e35886ec483fddec67b6f1203805f20f1547a" => :mojave
    sha256 "fd6e8d6700c8b76642b73e17bb8e35886ec483fddec67b6f1203805f20f1547a" => :high_sierra
    sha256 "e48b12c8423df69d64ab20a1a001e49a90d98fcbfec52ef20b2b47c93ed86ae3" => :sierra
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
