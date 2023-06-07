class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "5b5b502f33277d1ebdb39d57898b1ca25affef4819d390927499f368dd562d91"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c10bf98aced8268390a9bf28eaa31ab695fdca9800530de0b485afce40a4e490"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75b8c8d93328414e127b6159cf784c7fb75d29bd9e9b6b4652e812b1a894ead6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ded01c3e1711cbd688caa4812f709402589b4e1e52466ea6c9647b0a46f7bf50"
    sha256 cellar: :any_skip_relocation, ventura:        "3509a409b6afe6b75338a5dffa3c263ee85a2bb223275401abb823ae77da4adc"
    sha256 cellar: :any_skip_relocation, monterey:       "d1ee685ca4d67f220013e385fa71eb82903cd40fb7450bc2ac12df2805d586b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "90434fde8217542a4334e8758d76b0f791bb6c50aec04c29ad50e163b7bb2847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b693e63fc7ce68136fac7bf43bf02375fbad4aecb751827b312a70aa45cdb280"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "quill/Quill.h"
      int main()
      {
        quill::start();
        std::shared_ptr< quill::Handler > file_handler = quill::file_handler("#{testpath}/basic-log.txt", "w");
        quill::Logger* logger = quill::create_logger("logger_bar", std::move(file_handler));
        LOG_INFO(logger, "Test");
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test", "-pthread"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
