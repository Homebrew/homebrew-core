class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v0.16.0.tar.gz"
  sha256 "9e64e3b10c2a3c54dfff63aa056057cf1db8a5fd506b3d9cf77207511820baac"
  head "https://github.com/gabime/spdlog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10f214120f01c039d6f75faba940473c9d87250f06887205c2964851f3bad7ab" => :high_sierra
    sha256 "ccaa59f590a88ae154fa776bbfa0e795b073e7846140483f53bc8cfd2c35aa27" => :sierra
    sha256 "ccaa59f590a88ae154fa776bbfa0e795b073e7846140483f53bc8cfd2c35aa27" => :el_capitan
    sha256 "ccaa59f590a88ae154fa776bbfa0e795b073e7846140483f53bc8cfd2c35aa27" => :yosemite
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
      #include "spdlog/spdlog.h"
      #include <iostream>
      #include <memory>
      int main()
      {
        auto console = spdlog::stdout_logger_mt("console");
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-o", "test"
    system "./test"
  end
end
