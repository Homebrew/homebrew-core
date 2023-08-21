class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "f929d54a115b45c32dd2acd1a9810336d35c31fde9f5581c51ad2b80f980d0d1"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "822b07a5db06e4c5534bf883b77f8b9cde3ba0dc40fe0a7d128477607f65e815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a0aba4bdec65bf68e6a0a0ceb2198966c7b663cc143a30c922a9358a948b47b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ad335276cf1c17285eb3a5e64d2e45c569459bed782739ce58785b6ab930bb2"
    sha256 cellar: :any_skip_relocation, ventura:        "344ce641fde3447e43ce72c08760804dad26e997972237fbe71734b26f910173"
    sha256 cellar: :any_skip_relocation, monterey:       "6577c252f86173a2736b3cee297b99961442f128be9f3676f4c0b2c68a8b9335"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3f8f4b9825262accd30850c3a7517a91cf06b552a301240fe343df7258b8eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33555245b8c738d494e50d8de85dc8dd166e2fc6c0140c470596c9f5b495291c"
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

        quill::FileHandlerConfig file_handler_cfg;
        file_handler_cfg.set_open_mode('w');

        std::shared_ptr< quill::Handler > file_handler = quill::file_handler("#{testpath}/basic-log.txt", file_handler_cfg);
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
