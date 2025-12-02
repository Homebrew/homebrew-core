class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "8741753e488a78dd0d0024c980e1fb5b5c85888447e309d9cb9d949bdb52aa3e"
  license "MIT"
  revision 1
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48f60f6f26b8fcbaeba93f5e7f6ce09f4e2caabe401493e8704178e7cf900dd6"
    sha256 cellar: :any,                 arm64_sequoia: "4189a5a09f6df33310f087fc2f05b6efda61ce83bfa65d8f32c61b9eee3a27d7"
    sha256 cellar: :any,                 arm64_sonoma:  "722a5865c0eb6229a053dac16b1b656d571153362217f31ae927360a379a3220"
    sha256 cellar: :any,                 sonoma:        "bafe8b9c234a4c3794fd802f534e775ca5974315e7e0f0f65815300800d1ebe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fd0c9e79d3a2a6d1209fb05980640198f755689fd03fea8fb05b4eb00ff1938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc677e2642c10f480a0a1506a8737a27c72dc23ae45e806d5408156192ad411"
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
