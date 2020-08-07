class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.3.3.tar.gz"
  sha256 "5e185ebe7318fe8ce6e3fd849ec8f7fcb1298ab0302b2268382c7aef1c9542ce"
  license "MIT"
  head "https://github.com/odygrd/quill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5b1280005dc03fe5102a7fddf20fe9db69bde81ab595d6a114605af3084f01d" => :catalina
    sha256 "c4e09e9d6bc32efe49deff22ea23c4b05e2a6c0503622f720dc13f52d5382c69" => :mojave
    sha256 "6df03ce906ab57b2b4aae2c6bbca2ff509e9d731b44b2417e78a1908abea6516" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "quill-build" do
      args = std_cmake_args
      args << ".."
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "quill/Quill.h"
      int main()
      {
        quill::start();
        quill::Handler* file_handler = quill::file_handler("#{testpath}/basic-log.txt", "w");
        quill::Logger* logger = quill::create_logger("logger_bar", file_handler);
        LOG_INFO(logger, "Test");
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
