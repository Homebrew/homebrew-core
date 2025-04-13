class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "7a80896357f3e8e920e85e92633b14ba0f229c506e6f978578bdc35ba09e9a5d"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fce7e7460c9221b3cac3d0217cc0308805c7c30e4a01fcd7a8e76639029e6b67"
    sha256 cellar: :any,                 arm64_sonoma:  "fc56bc102f9b5fe33c7e30948fa92032116d0f56b2d57933da6310716f34dccf"
    sha256 cellar: :any,                 arm64_ventura: "fc03c6140eff2abbb534c3f5031fa2449ae0495c210868c323d8ef5ed2bd88e7"
    sha256 cellar: :any,                 sonoma:        "d504d88ce3da851f6d9ead5970f3cd6572c0333f1b86d5b7888628b202e5c806"
    sha256 cellar: :any,                 ventura:       "82e8917975135e05b0a741fac78d24592c91fd0034f691acc15dd9998b6f33e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c4880279f344e870b2c2bb96a4b1ca4eb489823e871e0c6b33520fa13e0fc02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "971b2b89a5d5952e49e93de2bcb504c68265bd108b19a265617d00908b8b16e1"
  end

  depends_on "cmake" => :build
  depends_on "fmt"

  def install
    ENV.cxx11

    inreplace "include/spdlog/tweakme.h", "// #define SPDLOG_FMT_EXTERNAL", <<~C
      #ifndef SPDLOG_FMT_EXTERNAL
      #define SPDLOG_FMT_EXTERNAL
      #endif
    C

    args = std_cmake_args + %W[
      -Dpkg_config_libdir=#{lib}
      -DSPDLOG_BUILD_BENCH=OFF
      -DSPDLOG_BUILD_EXAMPLE=OFF
      -DSPDLOG_BUILD_TESTS=OFF
      -DSPDLOG_FMT_EXTERNAL=ON
    ]
    system "cmake", "-S", ".", "-B", "build", "-DSPDLOG_BUILD_SHARED=ON", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build", "-DSPDLOG_BUILD_SHARED=OFF", *args
    system "cmake", "--build", "build"
    lib.install "build/libspdlog.a"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "spdlog/sinks/basic_file_sink.h"
      #include <iostream>
      #include <memory>
      int main()
      {
        try {
          auto console = spdlog::basic_logger_mt("basic_logger", "#{testpath}/basic-log.txt");
          console->info("Test");
        }
        catch (const spdlog::spdlog_ex &ex)
        {
          std::cout << "Log init failed: " << ex.what() << std::endl;
          return 1;
        }
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{Formula["fmt"].opt_lib}", "-lfmt", "-o", "test"
    system "./test"
    assert_path_exists testpath/"basic-log.txt"
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
