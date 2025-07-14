class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "15a04e69c222eb6c01094b5c7ff8a249b36bb22788d72519646fb85feb267e67"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b885d77ddec4626dd6f31bc9a94fae28b4bd3ac4e5e91c36624891d262d6d3de"
    sha256 cellar: :any,                 arm64_sonoma:  "222a1f363fe1b82e9e830c7a42f98d73c7b9673e7256502cdc66093193e2fee3"
    sha256 cellar: :any,                 arm64_ventura: "78d3b81c70195115a7d762b9b39efaef6d45652488654a1104c237138a5f3898"
    sha256 cellar: :any,                 sonoma:        "6407f99157debc92ed12594a56cc98b9513e6d3617c5bf0ccad7127c8e0340a1"
    sha256 cellar: :any,                 ventura:       "f62555b2fb8dcc64a581c3f2efca87e50b49aecbc62d3492b4fb910c97442cb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "774a3ccba115e20c6b0c594bb4c6b554de3c65f1454666d86a4aa0028d8591ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "334f9f05e98a52ecea6bbdbaebbfb597936d4169c935018eff7cd2f1789dcebd"
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
