class StanMath < Formula
  desc "C++ template library for automatic differentiation"
  homepage "https://mc-stan.org"
  url "https://github.com/stan-dev/math/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "9efbb1a9c40b5484b971a278bfef1b9fba3f0390af8d0d81928a820bb91a6781"
  license "BSD-3-Clause"

  depends_on "boost"
  depends_on "eigen"
  depends_on "sundials"
  depends_on "tbb"

  # allow system dependencies
  # https://github.com/stan-dev/math/pull/2659
  # part 1/3
  patch do
    url "https://github.com/stan-dev/math/commit/4e879c0c0e86053e93d41f1a5f1040e2d7c1b0c0.patch?full_index=1"
    sha256 "e3ca87f3f5918ddec49f9db64ef1d28bf77df1004963a1b1132aefe7a1df882c"
  end

  # part 2/3
  patch do
    url "https://github.com/stan-dev/math/commit/c0285859c1fa2eaa5dc47ae6883dca9c64b20bc5.patch?full_index=1"
    sha256 "1a7ce39ae90cb2b25713394263d049c3f26f819c9f791475c399e738d3472d14"
  end

  # part 3/3
  patch do
    url "https://github.com/stan-dev/math/commit/82d313eb036ed913afa5d07c25a01d126a821b20.patch?full_index=1"
    sha256 "2f74df376800e103e1c2c7283724e0c5a59f1ca36123ea9cf60fded4f14907be"
  end

  def install
    # remove bundled libraries
    rm_r "lib"

    (buildpath/"make/local").write <<~EOS
      BOOST_INC=#{Formula["boost"].opt_include}
      EIGEN_INC=#{Formula["eigen"].opt_include}/eigen3
      SUNDIALS_INC=#{Formula["sundials"].opt_prefix}
      SUNDIALS_LIB=#{Formula["sundials"].opt_lib}
      TBB_INC=#{Formula["tbb"].opt_include}
      TBB_LIB=#{Formula["tbb"].opt_lib}
      TBB_INTERFACE_NEW=true
    EOS

    # fixes unknown option: --disable-new-dtags
    inreplace "make/compiler_flags", " -Wl,--disable-new-dtags", "" if OS.mac?

    libexec.install Dir["*"]
  end

  test do
    (testpath/"normal_log.cpp").write <<~EOS
      #include <stan/math.hpp>
      #include <iostream>

      int main() {
        std::cout << "log normal(1 | 2, 3)="
                  << stan::math::normal_log(1, 2, 3)
                  << std::endl;
      }
    EOS
    system "make", "-f", libexec/"make/standalone", "normal_log"
    system "./normal_log"
  end
end
