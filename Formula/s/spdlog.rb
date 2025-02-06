class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "25c843860f039a1600f232c6eb9e01e6627f7d030a2ae5e232bdd3c9205d26cc"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "230a2a5681da618aa3888753225000a3ca8704be948f8f304e662027dfb7173e"
    sha256 cellar: :any,                 arm64_sonoma:  "15391b54002ac3fdcb6b12b1e99dd982d2b8bb4d88401e4351d71614a8198d30"
    sha256 cellar: :any,                 arm64_ventura: "3f8d302da9534fe6144c8abf8d9091f48d0a193822af0c66065c4bcf8a384c8d"
    sha256 cellar: :any,                 sonoma:        "7d5bf4df33d3a3b76010510e8120c49a7cd827be44a709207ee065dc5884f06a"
    sha256 cellar: :any,                 ventura:       "08824198423b4bfa3365c00a7680118b3941212db20fe8cbe7da27498f2de9a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08192ff5ff7f276d9727f5c8c4215be2e4c5b565544a777b4f238888102b854e"
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
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
