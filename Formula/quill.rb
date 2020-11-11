class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.5.2.tar.gz"
  sha256 "e409fda0bd949e997f63de4d422a8f17ccc9cb0d58f11403bd309c7a93aa0d6b"
  license "MIT"
  head "https://github.com/odygrd/quill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4a0159c34fd4d9423ec5987f1048bf96917d8abfe3895233a094c24a51416d2" => :catalina
    sha256 "f9c08577d2da98145a86c873bc7bbdb15b48c407e24d9aebe1095ad4257004e1" => :mojave
    sha256 "325aea23a3160a9cf19fbb2c90f4e4e5fa43e770ad9333e3db97aeb23e4462ff" => :high_sierra
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
