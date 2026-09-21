class Reproc < Formula
  desc "Cross-platform (C99/C++11) process library"
  homepage "https://github.com/daandemeyer/reproc"
  url "https://github.com/daandemeyer/reproc/archive/refs/tags/14.2.8.tar.gz"
  sha256 "27c3b452bfc419a2deda23969aa10c77909c4ff9e71c549eb65d09ae6aa7aa32"
  license "MIT"
  head "https://github.com/DaanDeMeyer/reproc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e9b8ee38d5e6e0273c2dad738f19588da3e5c6f9de5993e0d44452caa417d8bb"
    sha256 cellar: :any, arm64_tahoe:       "27f18791b89468ce7d3758a08063347709566ad357f3401a0261de11227a54e7"
    sha256 cellar: :any, arm64_sequoia:     "054a5692de1f7f7e626e0eb099f04e746de117f26660b52891097c9a1e7fb768"
    sha256 cellar: :any, arm64_sonoma:      "749a780b152fdc954e22bbcf9e012302600fc1412e4b58c30a654a52d2b77720"
    sha256 cellar: :any, arm64_linux:       "80ee42036c3ad55342d07b82905a35f67f3835bf7b00b9a3f71587e9064a7a31"
    sha256 cellar: :any, x86_64_linux:      "f2cede72d8fd93d40c627137bb45bc3b8a7193f2d64f2bbc8d9dcb9ec40b77ab"
  end

  depends_on "cmake" => :build

  def install
    args = *std_cmake_args << "-DREPROC++=ON"
    system "cmake", "-S", ".", "-B", "build", *args, "-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rm_r("build")
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    lib.install "build/reproc/lib/libreproc.a", "build/reproc++/lib/libreproc++.a"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <reproc/run.h>

      int main(void) {
        const char *args[] = { "echo", "Hello, world!", NULL };
        return reproc_run(args, (reproc_options) { 0 });
      }
    C

    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lreproc", "-o", "test-c"
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lreproc++", "-o", "test-cpp"

    assert_equal "Hello, world!", shell_output("./test-c").chomp
    assert_equal "Hello, world!", shell_output("./test-cpp").chomp
  end
end
