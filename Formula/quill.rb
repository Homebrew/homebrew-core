class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "4771dc08c0ff01cea9081d645ed7cae27cfa073185c986177ef3ce13743136af"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f881260752e56ab4aada797cd47763f7e75198880477b29b09a4f7215e240f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98c0690192fe231079e6dc4158981a6206549745c415a6aff284d7e0a6200e49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e54d5d7b4deb380ad8c3db42db4aa78627d7079bd87e6ebdf421909f67adf68d"
    sha256 cellar: :any_skip_relocation, monterey:       "226e3a7b183489b6787fad0b927b4e842eb77a09000a5e03533b638bb21ef434"
    sha256 cellar: :any_skip_relocation, big_sur:        "d096daa04f44428cf4cc7db8004fd2c4e09a8d074a70e26c158fb61a84ac2a70"
    sha256 cellar: :any_skip_relocation, catalina:       "2c5a8faa453435219fbc370aaad3dc1bbbba684f67763df2b0928f3c8d881b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a69a4a9bc0aa160e1d5378c8b5737bc37941fc834e41c23687f0de60de88fbc1"
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
