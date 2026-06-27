class Reproc < Formula
  desc "Cross-platform (C99/C++11) process library"
  homepage "https://github.com/DaanDeMeyer/reproc"
  url "https://github.com/DaanDeMeyer/reproc/archive/refs/tags/v14.2.7.tar.gz"
  sha256 "77914ba566356d86986db240ecdb1762dfdd55bb1e8e127d016d9c5c4c9300e8"
  license "MIT"
  head "https://github.com/DaanDeMeyer/reproc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "363f30f229b7760de3e9fcc16c2d135e40820158eb31d361e14e390082a87f71"
    sha256 cellar: :any,                 arm64_sequoia: "dcd90b82bef65e05b7b15f140ddd05e6719e4e3ff3f57bfc47bc0858817f8b51"
    sha256 cellar: :any,                 arm64_sonoma:  "200ef9bcad2c67420c4bc9ef922638a20d2e6367357221d86d5c59523de4f84a"
    sha256 cellar: :any,                 sonoma:        "e16eda0c89e30cf412e2f6efce08cfc475033fe05542d90adf0fa75ba4182894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd077225e9b235645914ea8907d2b9f6be2d27ba1698a666e498cda446dbb881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27c91b3b4bce3543982d7f23575385562f212875d65896e45671db768fd01e24"
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
