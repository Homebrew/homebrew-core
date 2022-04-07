class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.9.2.tar.gz"
  sha256 "6fff9215f5cb81760be4cc16d033526d1080427d236e86d70bb02994f85e3d38"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "1567906c33dc6a1fddaa1fdc430a4183fa7c7caf8cb61259561fbe42db2e149c"
    sha256 cellar: :any,                 arm64_big_sur:  "932380f1fdb3b4e841ea4c7e8bb2cccfeaf04916bc18b8af7c4791052e093733"
    sha256 cellar: :any,                 monterey:       "93bf8e394c6b17a6ac8e00bbb03fbe5d88b7066e4794c5f34f5394a393a9e531"
    sha256 cellar: :any,                 big_sur:        "7ef50412af9432c0ba4b686ca1d61e17dec36183fd898cf695c8eeac3157dd81"
    sha256 cellar: :any,                 catalina:       "111819301639a2b294d1e26cac9ca73a452407bdc7591aa1638ad3a03d4aed96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72c006ff7371b4b04bcb08fbbbe1efc72c9f693422d4b6e22ebc7aecb6bc9fb7"
  end

  depends_on "cmake" => :build
  depends_on "fmt"

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
