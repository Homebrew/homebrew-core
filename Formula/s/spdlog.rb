class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "534f2ee1a4dcbeb22249856edfb2be76a1cf4f708a20b0ac2ed090ee24cfdbc9"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "43bcdb69cb3a9a7428c8ff0bc0749d072b7b8a984a7534beafdb0b718f7de85b"
    sha256 cellar: :any,                 arm64_ventura:  "6d5fae89435460949aed7c8b37d9c64a5af5aaa64218d7dc4d2a13064c3b44ef"
    sha256 cellar: :any,                 arm64_monterey: "ffe6a1c28884c980bffb29abf5f9feed7cc8f9b363a2a6cbff14fad3e31dda07"
    sha256 cellar: :any,                 sonoma:         "bae142f1dffb1f4922c189b9a385fdec7fb6aac900148219fcaec8cacbe5d180"
    sha256 cellar: :any,                 ventura:        "0a1e50708d457e5bca58f8bafaabfc63430272546615ad7847dbaa27ce4a099b"
    sha256 cellar: :any,                 monterey:       "35d9e5f8db9a96930c3c807291800b7b3f79b75347cd9b9e59aa56d6c1c4b1f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fee4420a3817f82a555b8360e9a96680743e5e5f97ea779aa56a8ca0c6cfc4ad"
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
