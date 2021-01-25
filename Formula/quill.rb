class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.6.1.tar.gz"
  sha256 "282f54a67fecaa7f094cf986a9e2f7fab342f39e9167c76d7619ad531d0bbaa5"
  license "MIT"
  head "https://github.com/odygrd/quill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68eb91bec1bb6aa4940c8810fcc52249d481d561d330c3b47e1a81bf7ad04e05" => :big_sur
    sha256 "95fe2829bbb6e32603f6643bcee27c1d35cedbbe2a0fd46c68c9e761a69a2e20" => :arm64_big_sur
    sha256 "f2cbdd35b47985eb42e2704dcf66350bdedf9e81d71e2d180ed2c584882056ff" => :catalina
    sha256 "d44cf769025e1d4b1a0cb54e4f6868bbfd48f7b2f7b21d9043add433d3163244" => :mojave
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
