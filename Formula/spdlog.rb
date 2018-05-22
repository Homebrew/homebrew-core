class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v0.17.0.tar.gz"
  sha256 "94f74fd1b3344733d1db3de2ec22e6cbeb769f93a8baa0d4a22b1f62dc7369f8"
  head "https://github.com/gabime/spdlog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ad4050e75f506fe5d6cd5a36331058942e490755d565f0da8f1cc1b399e2b87" => :high_sierra
    sha256 "5ad4050e75f506fe5d6cd5a36331058942e490755d565f0da8f1cc1b399e2b87" => :sierra
    sha256 "5ad4050e75f506fe5d6cd5a36331058942e490755d565f0da8f1cc1b399e2b87" => :el_capitan
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
