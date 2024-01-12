class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "534f2ee1a4dcbeb22249856edfb2be76a1cf4f708a20b0ac2ed090ee24cfdbc9"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "65a9e01ffa151f110a87beca645ecd09aeaa6c4f9be28545fd46724c85bc07d9"
    sha256 cellar: :any,                 arm64_ventura:  "79c8ea7065e0350056c24504ffb9a3cee0591e931b51f88f051ef7c4661a491a"
    sha256 cellar: :any,                 arm64_monterey: "4e7c54a1932489df9f033c6ff38265c9561c749ae70ea8cc5c34b5a58d6d7ba7"
    sha256 cellar: :any,                 arm64_big_sur:  "a9be7e4e477200f9991fdf83fb40da314dd4fbedbd7dc4b6305f8951d9d49e57"
    sha256 cellar: :any,                 sonoma:         "9f1d3dc3d86fa87bfe2e9fb77332451acfc5c64b74a7531533c81a77772e89ed"
    sha256 cellar: :any,                 ventura:        "ef21f4e8f5977e10cca1ee2b747a40810fcaac67695e72f564df8bb6b1455938"
    sha256 cellar: :any,                 monterey:       "9d58adf3aabf5788f74938cd445d0129e458dbe7a238c88741e634f31debff0c"
    sha256 cellar: :any,                 big_sur:        "585a56f831fe23ca1f8137e6344a8469fe2f5e411c6a994615ff585be4574ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa1ba7fb7b814469c81c5eae8a607da65a4e6725a90b610a658e24d26ca037e8"
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
