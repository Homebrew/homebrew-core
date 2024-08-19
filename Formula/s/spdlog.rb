class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "1586508029a7d0670dfcb2d97575dcdc242d3868a259742b69f100801ab4e16b"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "25b98f9a432a924734c13ccf5ff201c1df0c50fe141b41d99e69599dd7b00670"
    sha256 cellar: :any,                 arm64_ventura:  "b5fd78a0347e7e35d3e4e22e41b6f5c48aefb34f990c94e370c74c4f2a0dac26"
    sha256 cellar: :any,                 arm64_monterey: "cc4fe928b44e3cdfa6ff6a069a70a52ab2d4e38a4982fbf2cc2a5aefa1149250"
    sha256 cellar: :any,                 sonoma:         "5fdbfa866ea2c90d7163358ebefa2862f58a9f85b44b921f39f8bc9ab2a70516"
    sha256 cellar: :any,                 ventura:        "5d1a5d09e968aed5c37a7c6b53893c3f18689396c5de1049db572a769f5cba63"
    sha256 cellar: :any,                 monterey:       "85dd11b2c4fe465fa11265472468801961b32074ce3007d227061a8d3b1c90f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe60f809aaac9294e33b36a6752d1b41d04b2fae8c3489a218924569a3250b62"
  end

  depends_on "cmake" => :build
  depends_on "fmt"

  # error: specialization of 'template<class T, ...> struct fmt::v8::formatter' in different namespace
  fails_with gcc: "5"

  def install
    ENV.cxx11

    inreplace "include/spdlog/tweakme.h", "// #define SPDLOG_FMT_EXTERNAL", <<~EOS
      #ifndef SPDLOG_FMT_EXTERNAL
      #define SPDLOG_FMT_EXTERNAL
      #endif
    EOS

    args = std_cmake_args + %W[
      -Dpkg_config_libdir=#{lib}
      -DSPDLOG_BUILD_BENCH=OFF
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
    (testpath/"test.cpp").write <<~EOS
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
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{Formula["fmt"].opt_lib}", "-lfmt", "-o", "test"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
