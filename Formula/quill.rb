class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v2.2.0.tar.gz"
  sha256 "6b123b60b16d41009228d907851f025c8be974d5fcf41af0b6afbe48edebbf73"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6b6f2a46adcfe06c1e8d72be422adc8c3ec7ff05df471c35e68af93fdac7480"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29ab9ddd25212a7bf167292a15df51643dbe4505e92fbc509687226de5d4ff4e"
    sha256 cellar: :any_skip_relocation, monterey:       "aafbe74438ce76cd8c8b5d0098db6536b1cbac9afb8c351955454f3da3b2daa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "17fdaadf3d8772cd0091f098974cb6c5099f2ff68744fc51f6f073642f4e3aa5"
    sha256 cellar: :any_skip_relocation, catalina:       "23383dafba958cdd763f4dffa27a2fb096e6ee6775b73fdb5852c45d2d1bf704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be5e9d7240b231908318db4ee7e778bb3a52ea097aba5fefaeaef416da84537"
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
