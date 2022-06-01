class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v2.0.2.tar.gz"
  sha256 "d2dc9004886b787f8357e97d2f2d0c74a460259f7f95d65ab49d060fe34a9b5c"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3dd00263847be710f058bc6cd6395c41d254c7c27177c427e0eb8d8ab2c8fc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eea3220d9dca9856367b5a9954ad6411c1493963bceb7631968ae0ec58b3876"
    sha256 cellar: :any_skip_relocation, monterey:       "b590cb7f606c77dcc54c97a000052705ae2fd12692f7e018f11b02e1a248a445"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc256f5c6fa1a2b648c0488aad6f59930f147fc911e9b7f640f1672046aa81ba"
    sha256 cellar: :any_skip_relocation, catalina:       "fcd86fd1ec214cc8ad5b6554d48f80e200464ce76811061d9976f56b3e8fb685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab2de46843bae5e9820b62cc6728bb24c7d40fe359711db394c17708ebcaba5c"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

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
