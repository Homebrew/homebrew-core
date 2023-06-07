class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.11.0.tar.gz"
  sha256 "ca5cae8d6cac15dae0ec63b21d6ad3530070650f68076f3a4a862ca293a858bb"
  license "MIT"
  revision 1
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a0c30483a7ad84c88b8923895eb8ea0b947a4f881f1832cee19ac40178efa256"
    sha256 cellar: :any,                 arm64_monterey: "4e6a3c5bd5ee30ee8675229ab4cb5a6259b9a6af9d4acc3f150b704924f95a20"
    sha256 cellar: :any,                 arm64_big_sur:  "33eb5e16ef220226228bcce2f3acaa1afe6004daa1a8853ad07a5096baf07e45"
    sha256 cellar: :any,                 ventura:        "016ebd2d21eff64a974f77db37486a78b57a2beed40c0cf7e5dee99e3afe74e8"
    sha256 cellar: :any,                 monterey:       "ca2f31535ea857bb4bdc3cbe8419c7b04d3f8798ce5041fee8fe20d05eb50d2a"
    sha256 cellar: :any,                 big_sur:        "72d83c7b857e96ad42ab8d233ef1f13c2a5f3317fa1db8eb95bd3e9cb72c5d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c8cd3a6cff86119e2a9ded0c739c76bcccc731de9cc990320d43423c4116f02"
  end

  depends_on "cmake" => :build
  depends_on "fmt"

  # error: specialization of 'template<class T, ...> struct fmt::v8::formatter' in different namespace
  fails_with gcc: "5"

  # Add support for fmt 10.0.0
  patch do
    url "https://github.com/gabime/spdlog/commit/0ca574ae168820da0268b3ec7607ca7b33024d05.patch?full_index=1"
    sha256 "31b22a9bfa6790fdabff186c0a9b0fd588439485f05cbef5e661231d15fec49b"
  end

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
