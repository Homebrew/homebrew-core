class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v0.16.0.tar.gz"
  sha256 "9e64e3b10c2a3c54dfff63aa056057cf1db8a5fd506b3d9cf77207511820baac"
  head "https://github.com/gabime/spdlog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccde519ebd3074340b45293c5db55aa4069f4855fa6d833376a0606185d995cd" => :high_sierra
    sha256 "ccde519ebd3074340b45293c5db55aa4069f4855fa6d833376a0606185d995cd" => :sierra
    sha256 "ccde519ebd3074340b45293c5db55aa4069f4855fa6d833376a0606185d995cd" => :el_capitan
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
