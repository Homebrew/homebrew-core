class Spdlog < Formula
  desc "Super fast C++ logging library."
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v0.13.0.tar.gz"
  sha256 "d798a6ca19165f0a18a43938859359269f5a07fd8e0eb83ab8674739c9e8f361"
  head "https://github.com/gabime/spdlog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "162184d4c669bf4ec4f87166e87215b7eff9ae9cdc21a52ea1355b9324386604" => :sierra
    sha256 "162184d4c669bf4ec4f87166e87215b7eff9ae9cdc21a52ea1355b9324386604" => :el_capitan
    sha256 "162184d4c669bf4ec4f87166e87215b7eff9ae9cdc21a52ea1355b9324386604" => :yosemite
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
