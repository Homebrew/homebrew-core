class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v2.2.0.tar.gz"
  sha256 "6b123b60b16d41009228d907851f025c8be974d5fcf41af0b6afbe48edebbf73"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9da39652cc8a8062fb29f133cca8169fcc97a7d99e274354ceeae53f4fa631ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "358f4fdc5c5af2ba5a66f1cd289d527d021c2ac215c3b99f0bd3f73415eac949"
    sha256 cellar: :any_skip_relocation, monterey:       "96f579939efcd4561b42b35ada08992ccf3ed5ea8674f3ac4148fda74bd9a5ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "d46bffb6fe69bb16447610147df267527eab987e9b102383a09d0d7e0b8bad89"
    sha256 cellar: :any_skip_relocation, catalina:       "95470ef86303a15a927b293383935f68c99d7ee72ab6eebdce7c432a0f451d13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3440c7c92f4cf8f3980028c8d861743af7e77eb45c18efa8e9ad78868252f135"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina

  fails_with gcc: "5"

  def install
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

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test", "-pthread"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
