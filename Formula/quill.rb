class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.7.3.tar.gz"
  sha256 "3fff0c5ffb19bbde5429369079741f84a6acce3a781b504cec5e677b05461208"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de206cf0780f75b68232542308d4048b0a3d8401d1f53830cb59870a858c1801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7257a7071e685eed3ade9269180791cfb797c13112cf4846e4a495423901f919"
    sha256 cellar: :any_skip_relocation, monterey:       "22cc4b956f8655f63898b32c5866b973aa44883243b3383447f8b459922d8982"
    sha256 cellar: :any_skip_relocation, big_sur:        "1307e4c852a0709a5a659f88820ac4b1c498df9ae7a0cf678f5f94734538491b"
    sha256 cellar: :any_skip_relocation, catalina:       "7f744ab6e5233bb07966cd656d49e3c564aed8dbf9efe651c6ffe92f4ab1959b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bf9ab49b4b2d60db611dcdc6c9e59beac5a8a244c298b1a2b40f5a4fc02ea32"
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
