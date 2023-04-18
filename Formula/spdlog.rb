class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.11.0.tar.gz"
  sha256 "ca5cae8d6cac15dae0ec63b21d6ad3530070650f68076f3a4a862ca293a858bb"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "99f6597478677431b87f16344e2797a5bd544ea47c7ca69cef6ddac79953550f"
    sha256 cellar: :any,                 arm64_monterey: "63af198f33b09b066fff8439967858c2d2598d7a7af55c90bb44479439de8e4d"
    sha256 cellar: :any,                 arm64_big_sur:  "849241d6a48c7c57f519011e816e0c910b9183dcedcb5b8a8d00aa17e12e32d6"
    sha256 cellar: :any,                 ventura:        "bda7921ac0e39a711900fc289205dee7a55596811e365f186cd1fa2c2ee30967"
    sha256 cellar: :any,                 monterey:       "fddfdf57dbd012a95cd5c7d23a130f68066a1f41419f6af42221d983b60c413f"
    sha256 cellar: :any,                 big_sur:        "638f2bde2ad93fadb73c367d0508643773c04f76514b139aa87b07d47ad53222"
    sha256 cellar: :any,                 catalina:       "6c3c582b7873203303b2295678256e560b58be94f02e6654c9289801b25bd7d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90bdf0ffb1445c3feb3e7541fa6d87bda07353cd938571d96c68aba274862a80"
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

    mkdir "spdlog-build" do
      args = std_cmake_args + %W[
        -Dpkg_config_libdir=#{lib}
        -DSPDLOG_BUILD_BENCH=OFF
        -DSPDLOG_BUILD_TESTS=OFF
        -DSPDLOG_FMT_EXTERNAL=ON
      ]
      system "cmake", "..", "-DSPDLOG_BUILD_SHARED=ON", *args
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DSPDLOG_BUILD_SHARED=OFF", *args
      system "make"
      lib.install "libspdlog.a"
    end
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
