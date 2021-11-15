class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.6.3.tar.gz"
  sha256 "886120b084db952aafe651c64f459e69fec481b4e189c14daa8c4108afebcba3"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d43aba895c3307a5965b4cdb34124967af8f748c5da80d7d9b0842c88d979eed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20314cbc7129a86e7431687ba26d26ba0add0e115e80536b02dfcf5398217097"
    sha256 cellar: :any_skip_relocation, monterey:       "94577e70e360724ae8e3fa750d6f210e4b14ebcf5eb946caf051dafda0276cb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "22f64135866f9600feb5495d4a8b58b29ef1f7c02de8edafe50960b2595910aa"
    sha256 cellar: :any_skip_relocation, catalina:       "2112f5965f599db294f9e2c2cfb86acf39b8482120c181cf841ee2a569e7c30e"
    sha256 cellar: :any_skip_relocation, mojave:         "d8a4190b8461b8860363d96a0623e4ad75a1da416a21bcc48a00340f50ce41ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3daaf537147bfa374930cb088a271cb735d42a12f208727680e578eef62a0f38"
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
