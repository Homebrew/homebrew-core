class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.6.0.tar.gz"
  sha256 "0421667c9f2fc78e6548d44f7bc5921be0f03e612df384294c16cedb93d967f8"
  head "https://github.com/gabime/spdlog.git", :branch => "v1.x"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cf71927ecad69460cb7be56e2bf8c0a00ddfcf5b861949f7b97627805e7b2e2" => :catalina
    sha256 "1cc93582e0b67e12aeb8da4cf0f4ebb69eeb1f1c28a9bff53e9c93713d885198" => :mojave
    sha256 "52ad29f8de732c24697f74f425c825bb9e1cf98356dadab79623441ad4c34a04" => :high_sierra
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
