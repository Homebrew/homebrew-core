class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.7.3.tar.gz"
  sha256 "3fff0c5ffb19bbde5429369079741f84a6acce3a781b504cec5e677b05461208"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4d1156c5e15f71b4431e3bfce7813de6ecac7f65fe564ff444a8f34fff89192"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd3a53ddde24590eb81882f8f297e74fd8555de87f08d6a9c7e2ace4df41739f"
    sha256 cellar: :any_skip_relocation, monterey:       "0545c76cfaf31b9183fbe1a307a022bba058be60fd719af2e302be5d412875e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3a50bf8db2b560acd26ab61519ab0fd9664520cc4f88955ebe72f3e4b215f35"
    sha256 cellar: :any_skip_relocation, catalina:       "2526b1dd073fbc7c872787128585765bdc61c420e687ae675aec2cdfd6f989a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "014d8a5d06e471b29604c26c0b167d7328f5cd95fbb6cdc77d9c172f1a16c6da"
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
