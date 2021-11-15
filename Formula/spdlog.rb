class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.9.2.tar.gz"
  sha256 "6fff9215f5cb81760be4cc16d033526d1080427d236e86d70bb02994f85e3d38"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3322b0afb1b04d54503384ad22c23b0d7f93ef7f949bb1c0623a112df7adbe6d"
    sha256 cellar: :any,                 arm64_big_sur:  "4ffc35695b060c0536b2da195a3e17019e345c4ae1a04bcef695a78eac18f945"
    sha256 cellar: :any,                 monterey:       "31453c1aa5554e71df3aed23dab4b466f02fae0d5d97d4a0fd8f60405ebca35d"
    sha256 cellar: :any,                 big_sur:        "a69e4c91e48164a21c96f572fb9c0a2168720bb3ab17f0ae68d91417b0b65d94"
    sha256 cellar: :any,                 catalina:       "64def8f9d455b8cb5bd4ba01419a20a1fa9a15377c0732d2c5a6133be404f586"
    sha256 cellar: :any,                 mojave:         "0db125fdda8f582b16d7505fd20a8776947e5bedb185a1cf42081717fbb9a6fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bd455a6f7631522c4de6147e8dfcb7ffbd0845bdfa9effb05918304f5d68f4d"
  end

  depends_on "cmake" => :build
  depends_on "fmt"

  def install
    ENV.cxx11

    inreplace "include/spdlog/tweakme.h", "// #define SPDLOG_FMT_EXTERNAL", "#define SPDLOG_FMT_EXTERNAL"

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
