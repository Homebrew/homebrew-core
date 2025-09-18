class Reproc < Formula
  desc "Cross-platform (C99/C++11) process library"
  homepage "https://github.com/DaanDeMeyer/reproc"
  url "https://github.com/DaanDeMeyer/reproc/archive/refs/tags/v14.2.5.tar.gz"
  sha256 "69467be0cfc80734b821c54ada263c8f1439f964314063f76b7cf256c3dc7ee8"
  license "MIT"
  head "https://github.com/DaanDeMeyer/reproc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a9dc4b5152435ee4d4d0a3507837b170a60b74bc69c62942d790a475a799e20e"
    sha256 cellar: :any,                 arm64_sequoia:  "d0c6ae20f545beb6bcdf1cef7492705e3ee5985c17799f43d4877d5d4c69db2c"
    sha256 cellar: :any,                 arm64_sonoma:   "4d56ba8e140f0ec062188d880a89853361a324a276042f87dfd7534879a8c1f1"
    sha256 cellar: :any,                 arm64_ventura:  "95bc077fda0d3238e9a6d7bee628adcc5cf3fd90268b8e4ee96c97e075d97f74"
    sha256 cellar: :any,                 arm64_monterey: "55aebee60bafdc235d68c900974ae1f27eb06e359fd760c2e90772d8bb783b2f"
    sha256 cellar: :any,                 sonoma:         "d3c2d756ae1b3b10b4c5d4d4f820612a7d47b5c0a028b19da44bc730dbe3f862"
    sha256 cellar: :any,                 ventura:        "12c715872d3f5471d6290cd8e9500caca92f5cd366d66c27a5a97deb5d7621eb"
    sha256 cellar: :any,                 monterey:       "7da06d575b4806cf58d434e9a86194173dd19eb30e7c34d08850da3124d61123"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cbfbe1cfa82ec3ccb364ab971a8d7dcfaacd98c708a57f1c3b4031381e745896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "693fb2c4503373a230ecae82f0b78cf91c2c83da3d7e16bb88c4d7efc86b7fae"
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
