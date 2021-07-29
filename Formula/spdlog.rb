class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.9.1.tar.gz"
  sha256 "9a452cfa24408baccc9b2bc2d421d68172a7630c99e9504a14754be840d31a62"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "16a01aa6326ba369f3b1444969b3c6404752058f3c520ab7deed1bb05b27ae83"
    sha256 cellar: :any,                 big_sur:       "4f4ccddb0cb5a2868c2abb930edb10db00b9a424359cfd00f960e342b7192c50"
    sha256 cellar: :any,                 catalina:      "64679359dccef4c95d23522c0ec9ee883a764988b5f57af5a0025b68aeb331a9"
    sha256 cellar: :any,                 mojave:        "086b5db228715bf36c75abf1995922229190705b8765ab97263fb5ca7c4922b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de303f34a9b248165c9aa40cf483a96e5e214ccbf521f5e905a45125c5d6fa92"
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
