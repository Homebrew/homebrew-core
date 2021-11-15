class Reproc < Formula
  desc "Cross-platform (C99/C++11) process library"
  homepage "https://github.com/DaanDeMeyer/reproc"
  url "https://github.com/DaanDeMeyer/reproc/archive/refs/tags/v14.2.4.tar.gz"
  sha256 "55c780f7faa5c8cabd83ebbb84b68e5e0e09732de70a129f6b3c801e905415dd"
  license "MIT"
  head "https://github.com/DaanDeMeyer/reproc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7ca8c71697fde21aee214aa89b946c8888fc705158a7ca0ab69517bd197a6da9"
    sha256 cellar: :any,                 arm64_big_sur:  "d470a5392162d5fb1f55278e6929848e83ae94cabab1df336e37a129c8ad283c"
    sha256 cellar: :any,                 monterey:       "83ea02414a36a147e2aa5b10af9dd1ffb54ab9264a41494f1445f74719705627"
    sha256 cellar: :any,                 big_sur:        "c78f3749af6dd54bc49284a537bd4fd12e63c205912e5c9ac94315c02806e6a1"
    sha256 cellar: :any,                 catalina:       "73c318ae34404846109bd408e4d47ed22581f3b6666458a9c6d8595281fb0046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d89df90f4fac92f1c189ced3417a439ae2b774b9653bc16ac6abcc352f1b26d"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

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
