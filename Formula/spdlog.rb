class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.4.1.tar.gz"
  sha256 "3291958eb54ed942d1bd3aef1b4f8ccf70566cbc04d34296ec61eb96ceb73cff"
  head "https://github.com/gabime/spdlog.git", :branch => "v1.x"

  bottle do
    cellar :any_skip_relocation
    sha256 "1efe3832423a602277216682867e629eb502e1d0f85d515ff5788bdb5942d427" => :mojave
    sha256 "cddf40655fd0a2916be6a0ecb587126b906e3059d0301d7f61d96e177b77d4fe" => :high_sierra
    sha256 "cddf40655fd0a2916be6a0ecb587126b906e3059d0301d7f61d96e177b77d4fe" => :sierra
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
