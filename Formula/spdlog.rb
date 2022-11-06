class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.11.0.tar.gz"
  sha256 "ca5cae8d6cac15dae0ec63b21d6ad3530070650f68076f3a4a862ca293a858bb"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6ea13e53ac7e416ee0a9017cabdb70ac355173301a98e39cd3c237a40eef5f27"
    sha256 cellar: :any,                 arm64_monterey: "326a1cec2e046ff0d9e7648f503be5b31b287e6fea68bc7c3d75e47504eef351"
    sha256 cellar: :any,                 arm64_big_sur:  "118df7717927021e813cbf6d084bc386c3a44a0b0641c062333f2bb204697eb3"
    sha256 cellar: :any,                 ventura:        "4b9703e62937a0ef07da51e02c0b65ed43c2749c1154e4e95f6a6fad81834081"
    sha256 cellar: :any,                 monterey:       "1d5f317ee2168fee8b91402fb4c5d3f6a8613780256b929fabd112532bb115e9"
    sha256 cellar: :any,                 big_sur:        "5597ce08bfbb2d6602a885131e2b55aed49e24a6edef51640ddab24d7f0ed7bc"
    sha256 cellar: :any,                 catalina:       "218aa5f6d88c3df0671e38dd5bb5c3e61b52807ba11593dfdd73ee53b3bfeb9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f2f10b826d54cdb6a3e8a40081cd705bfaea8ed66573c0d590f75d1f9bea009"
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
