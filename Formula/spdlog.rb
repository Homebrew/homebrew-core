class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.4.2.tar.gz"
  sha256 "821c85b120ad15d87ca2bc44185fa9091409777c756029125a02f81354072157"
  head "https://github.com/gabime/spdlog.git", :branch => "v1.x"

  bottle do
    cellar :any_skip_relocation
    sha256 "1da1f6ec2838ec29dc3341ac3cdc7e91cb7e57e7c642d6a98d28e8b8be2cf18e" => :catalina
    sha256 "d39eca268ff643b1cf421917e284750e5e2be84ef411663951e07aad89ce7cda" => :mojave
    sha256 "eb009f8a8e0bfd684f1c482d9a692a6f3de043c792c8fa51100c55c9c7cb45cd" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "spdlog-build" do
      args = std_cmake_args
      args << "-Dpkg_config_libdir=#{lib}" << "-DSPDLOG_BUILD_BENCH=OFF" << "-DSPDLOG_BUILD_TESTS=OFF" << ".."
      system "cmake", *args
      system "make", "install"
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

    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-o", "test"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
