class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "1586508029a7d0670dfcb2d97575dcdc242d3868a259742b69f100801ab4e16b"
  license "MIT"
  revision 1
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "294c2eacc174d2112dcb7d43a3b952c6051da94b1c835f61859d3673c97571ea"
    sha256 cellar: :any,                 arm64_sonoma:   "94a51165d021eedd4262d15dad7c14c83f0f33eeda096d86ee762f08f831bbba"
    sha256 cellar: :any,                 arm64_ventura:  "fa3a2b18afd9c0b6211a2315d253360a9ba5bcc3256303cc8ad6cce5ebd3586c"
    sha256 cellar: :any,                 arm64_monterey: "d0c4e6684ca59fa4859bd412003c25847f9e377f1151404ce293d5aeb5d13980"
    sha256 cellar: :any,                 sonoma:         "6ffe5ad092446c9c74b4a72e10b1f77daf4ea21d6fe5fa29cbeead408be37210"
    sha256 cellar: :any,                 ventura:        "3186075434c83929ac6d41bfd2d48edd6bafa7e84c03600c6718f4c606068e47"
    sha256 cellar: :any,                 monterey:       "044d54b7073502383bb0776f545dde9a98178ba4da6e40e7d2a62adf1e799ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89a7b397614d329f87cdc031c3b6842e0526827f4a5b6de2ee4f06d369068766"
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
