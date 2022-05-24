class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.10.0.tar.gz"
  sha256 "697f91700237dbae2326b90469be32b876b2b44888302afbc7aceb68bcfe8224"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7b4d6e509be406ad97572f6408ecfcfc5565258baf2935e670395c36643ef765"
    sha256 cellar: :any,                 arm64_big_sur:  "b2effb44f912c9c65095f21777d531c0f1bf6bed8e3ecc8baa819506b7b3f553"
    sha256 cellar: :any,                 monterey:       "61dae95a690c2148b523e4a8bb7b6e21def2affc652d7992301dac2ddb623f3b"
    sha256 cellar: :any,                 big_sur:        "c69fab2e50fa9e03f3c5ebbec80833f5c1e8d6dd09fcf3841095e643a762b71f"
    sha256 cellar: :any,                 catalina:       "72c5a9859d85d7271af9f61e56f242c6ec295f99ab0d5e456beca62309e31d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b3f7c2bf0719825dd85f844992d33255cbe7fbaa4971c83a2cc99f2a71e67a"
  end

  depends_on "cmake" => :build
  depends_on "fmt"

  on_linux do
    depends_on "gcc"
  end

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
