class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "d72fd5a01bf8d3e59ed93a789a8f103bc31efe0fb3c09182c74036a2e3a8451b"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9c62729b98983adb8021090b62b2a9950105831f0a75363991bd6e99899e76d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "629fcca9022fd5c11458fa8179f1d0a40ecb348cab4542cd80e456950e4a28cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04cbb1d928528f45fc9d592f5303da1c946e682047835506b415736dcc56fb40"
    sha256 cellar: :any_skip_relocation, ventura:        "3b2ad242c0cb233562471c7df66c671f23238983accfb9ee22e9c6c6bb5b9791"
    sha256 cellar: :any_skip_relocation, monterey:       "a8e5b033329886e805ccf807da51a8a1270c7a2ae7dfbb728a01a5488d923114"
    sha256 cellar: :any_skip_relocation, big_sur:        "4da7d742b6f4e8d0ef68a0c97ea9da079e5500d5fb4a8f811eab0302870fff16"
    sha256 cellar: :any_skip_relocation, catalina:       "f532af9b22f53cf38288a45c6ce3962aab956847cdadfbbb6a939653b2d39011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d07a25bcf3e08e748ef09e44492fee65c4f710d291ed64eaa7558d5b94b5839"
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
