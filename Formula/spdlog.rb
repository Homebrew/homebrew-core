class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v0.16.3.tar.gz"
  sha256 "b88d7be261d9089c817fc8cee6c000d69f349b357828e4c7f66985bc5d5360b8"
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
