class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.7.2.tar.gz"
  sha256 "e2153c6e25f3a6cee47c2a9edbabdace418f6d64f62cd701dfdae38d5892bb1b"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42a01e29d978fc99b2bb89b90a60e71556e1e2bcfa25426e1f9eb3f5a01628d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdfaeea9b2ff14f1d9795b0fad67b399fbe35189a6a7078fd33a16f95b5a10c9"
    sha256 cellar: :any_skip_relocation, monterey:       "1be17c97aebd224854d96a15891a9b5ecaa5de14add0124186ad838ea1b034b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "acd6751af2228616270eb47aa5790caf3f1b1e35021a10f0132e7ec35ea894c4"
    sha256 cellar: :any_skip_relocation, catalina:       "57197bc0f308c463a5d6f3d281b5b0cea4892d83e28b2d79dd9ff30c72d90fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "199e4ef74fb87b1101452ef8d8726d7d0a4698de8748795d3ee0470a81c1c3a0"
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
