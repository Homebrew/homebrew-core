class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.1.0.tar.gz"
  sha256 "3dbcbfd8c07e25f5e0d662b194d3a7772ef214358c49ada23c044c4747ce8b19"
  head "https://github.com/gabime/spdlog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d084c2d0651856ffde9c40995a7628733c3a964f9a3222b184c2a7ff678fb4b" => :high_sierra
    sha256 "8d084c2d0651856ffde9c40995a7628733c3a964f9a3222b184c2a7ff678fb4b" => :sierra
    sha256 "8d084c2d0651856ffde9c40995a7628733c3a964f9a3222b184c2a7ff678fb4b" => :el_capitan
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
