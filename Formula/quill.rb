class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.6.3.tar.gz"
  sha256 "886120b084db952aafe651c64f459e69fec481b4e189c14daa8c4108afebcba3"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01409dc369de300077b23a0c5bf2fb6bf677ed66fca43712f5fe084d47361fec"
    sha256 cellar: :any_skip_relocation, big_sur:       "b02566a1d53b41e8d09e828183cce4be7e80533671f952173576db728c4927f3"
    sha256 cellar: :any_skip_relocation, catalina:      "0745cc442c7e9f71dc999cc47acc6b6147d8ccbdf0c1261da7fdebd526c53ff8"
    sha256 cellar: :any_skip_relocation, mojave:        "dbcd03e89bea2d0817561537857268a7cbb216efaa1b182cfe297ed8f3968737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d2c2ca95ff4daeb3bbb738ff5db920a5ba312e38cff09749e1c2d70358f692c"
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

    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test", "-pthread"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
