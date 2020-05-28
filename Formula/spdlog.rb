class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.6.1.tar.gz"
  sha256 "378a040d91f787aec96d269b0c39189f58a6b852e4cbf9150ccfacbe85ebbbfc"
  head "https://github.com/gabime/spdlog.git", :branch => "v1.x"

  bottle do
    cellar :any_skip_relocation
    sha256 "07c17bdb70d3636bdf286398c110c27f2ef8bb80546ba806155a369fac4b2fdb" => :catalina
    sha256 "42051034228c55c6635971bbad18a6c9edd4fca4b9f89da22281948d10ec73a9" => :mojave
    sha256 "10b05175fc7bebc092a4fe504eff77c1aacb5690f77cbaca75948f71f4dc10e3" => :high_sierra
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
