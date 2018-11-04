class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.2.1.tar.gz"
  sha256 "867a4b7cedf9805e6f76d3ca41889679054f7e5a3b67722fe6d0eae41852a767"
  head "https://github.com/gabime/spdlog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "727a543cc70521b2001d46c8d0ff809b5471a80877a17389107f4fd475058e69" => :mojave
    sha256 "fac46636becf90fdf7cbe169422b7a11934ac7656a3e601f462947197e6a24a3" => :high_sierra
    sha256 "fac46636becf90fdf7cbe169422b7a11934ac7656a3e601f462947197e6a24a3" => :sierra
    sha256 "fac46636becf90fdf7cbe169422b7a11934ac7656a3e601f462947197e6a24a3" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11

    mkdir "spdlog-build" do
      args = std_cmake_args
      args << "-Dpkg_config_libdir=#{lib}" << ".."
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
