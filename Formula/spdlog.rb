class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.10.0.tar.gz"
  sha256 "697f91700237dbae2326b90469be32b876b2b44888302afbc7aceb68bcfe8224"
  license "MIT"
  revision 1
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fe0ed113f060d66db62d0125ffef8911ecbc8e93fd30bfb18640fd6b46325fe2"
    sha256 cellar: :any,                 arm64_big_sur:  "6bbf09c0127d340a689be6e1f5ea2ca35fff2b17010a6bdb5808ce3d08e68f26"
    sha256 cellar: :any,                 monterey:       "38225aaf1bfe551a3c60ea6fef5d13af141d17bf932db223a027f2ad4abcbfce"
    sha256 cellar: :any,                 big_sur:        "9db7990165f2c4058e226fce3708399eea2ae28014ec99ef14f2eb62a4fa7e19"
    sha256 cellar: :any,                 catalina:       "da74ac7fe12c3fd2c48a5d947415696732e6a183058a2f24815c12d21da96e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13fa847f070d9ce43c8249cbcba901702b76d48ff40e9a0887601bfc4442ba26"
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
