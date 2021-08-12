class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.9.1.tar.gz"
  sha256 "9a452cfa24408baccc9b2bc2d421d68172a7630c99e9504a14754be840d31a62"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0705ae2e6ba3fb2baf380b8a823610ddb7e06d1b41d0a0c9c544ce58af6c20ff"
    sha256 cellar: :any,                 big_sur:       "75cbf0a95bcc984e80ceb86e120738eb1e1bacd0f2e4b4d560e6d8a2400a84bd"
    sha256 cellar: :any,                 catalina:      "4045958290eb46042d3bdcf2f24e006aa53b0c55e7d64498f400bd80c20e16bb"
    sha256 cellar: :any,                 mojave:        "88da16a7035a12e274e6f67ec06d245c0bfb4b8e1154687bcb3d311de4a498a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55f68b9563e4ed70b92296a6fe84cbd4f84111544a1104679e28c34dc380ee16"
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
