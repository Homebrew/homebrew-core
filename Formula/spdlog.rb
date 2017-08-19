class Spdlog < Formula
  desc "Super fast C++ logging library."
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v0.14.0.tar.gz"
  sha256 "eb5beb4e53f4bfff5b32eb4db8588484bdc15a17b90eeefef3a9fc74fec1d83d"
  head "https://github.com/gabime/spdlog.git"

  bottle do
    cellar :any_skip_relocation
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
    (testpath/"test.cpp").write <<-EOS.undent
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
