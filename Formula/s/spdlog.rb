class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "9962648c9b4f1a7bbc76fd8d9172555bad1871fdb14ff4f842ef87949682caa5"
  license "MIT"
  revision 1
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3dc996b22567b1145fb0824b2c18055c1118c20cd204b74d9dc669e2e9685e2f"
    sha256 cellar: :any,                 arm64_sonoma:  "076cf115fe4d4a1015daad980bdbf002a9b8bf2a3c2572051dae8b5dee27077a"
    sha256 cellar: :any,                 arm64_ventura: "0fa5d95d90aea0050a169b19fc587556f138f6c2c7fd3690889b110b4610dabc"
    sha256 cellar: :any,                 sonoma:        "fbb802e3c297a881ab963a712312b4ce325b610ddff842bcf7e7d9f1ef2a7171"
    sha256 cellar: :any,                 ventura:       "9c323cf25b6c23675718bdf05eefb2d258525d76af383b6841e18eb177ebc43e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa5aa509df9f72672eabb2b4b5a3863288f433ea3e29909b63bf61c4cb38fc17"
  end

  depends_on "cmake" => :build
  depends_on "fmt"

  # fmt 11.1 compatibility patch, upstream pr ref, https://github.com/gabime/spdlog/pull/3301
  patch do
    url "https://github.com/gabime/spdlog/commit/e693420a38b58d29a56b3ea921e15b175a5f2843.patch?full_index=1"
    sha256 "70555a85ae64b55deeaa4cec8397e6a81e5cc44bc18ed39e98a97f331c61417a"
  end

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
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
