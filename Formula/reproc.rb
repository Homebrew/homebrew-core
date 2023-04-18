class Reproc < Formula
  desc "Cross-platform (C99/C++11) process library"
  homepage "https://github.com/DaanDeMeyer/reproc"
  url "https://github.com/DaanDeMeyer/reproc/archive/refs/tags/v14.2.4.tar.gz"
  sha256 "55c780f7faa5c8cabd83ebbb84b68e5e0e09732de70a129f6b3c801e905415dd"
  license "MIT"
  head "https://github.com/DaanDeMeyer/reproc.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "92dfc69a9bdaf3fe24d6a0e9614991fb7d76555b11744ff1a486fa153c4af70b"
    sha256 cellar: :any,                 arm64_monterey: "1d50813532d791a9709b50e885a5624d1df39fb9c37661472859c3a26670a2a6"
    sha256 cellar: :any,                 arm64_big_sur:  "38e7d2580d04f3d0929c6e60ef97cf19da2dd084f920d26a6a11e10c811de7ae"
    sha256 cellar: :any,                 ventura:        "bd24d6a297d490c2f97bf9e81ef43ca13da3a431268a4601ba103e1d25802578"
    sha256 cellar: :any,                 monterey:       "46ee83678708da249ff86807ae8d1c325a1f45c433adf4b2a9b2fe978406f133"
    sha256 cellar: :any,                 big_sur:        "eca3bef688c4b569bdfc5553518d9e5fb943d03d4d3e84ac8efb7fc4dd780db8"
    sha256 cellar: :any,                 catalina:       "c4d326f594531cea94259af9fe79a1e0efd8f1aafa1b9293b5ba536673308f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bba935ec5f089ca4705e6402d440eaef6c64eaaac73b6fa95baa68af69fc826"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    args = *std_cmake_args << "-DREPROC++=ON"
    system "cmake", "-S", ".", "-B", "build", *args, "-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rm_rf "build"
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    lib.install "build/reproc/lib/libreproc.a", "build/reproc++/lib/libreproc++.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <reproc/run.h>

      int main(void) {
        const char *args[] = { "echo", "Hello, world!", NULL };
        return reproc_run(args, (reproc_options) { 0 });
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <reproc++/run.hpp>

      int main(void) {
        int status = -1;
        std::error_code ec;

        const char *args[] = { "echo", "Hello, world!", NULL };
        reproc::options options;

        std::tie(status, ec) = reproc::run(args, options);
        return ec ? ec.value() : status;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lreproc", "-o", "test-c"
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lreproc++", "-o", "test-cpp"

    assert_equal "Hello, world!", shell_output("./test-c").chomp
    assert_equal "Hello, world!", shell_output("./test-cpp").chomp
  end
end
