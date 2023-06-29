class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "76e9f607168f71cf1028ae7374fbe91225e400c11b5a51a6ebc992c85d012eed"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7283b86a2309ac5bed0875c3526917d5e845afa763547c9656aaf19151ccdc5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0d00fb11f62c2806eb0fdb7593b0a5018ddbbab827edf919630ec185c68bcac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de4fdb92d1512adfb61bd3b60b1cd3b240697cf7f80733b1a386fbaebe3b8229"
    sha256 cellar: :any_skip_relocation, ventura:        "ae822e0138c481db1bf5c4ad52639069c876b6c07e8fb02cbcea194ef33d8d75"
    sha256 cellar: :any_skip_relocation, monterey:       "4a19ea55a87ebd9145a085dcc2f60d9538e786455d8c3d2b56ff7d0495d94e87"
    sha256 cellar: :any_skip_relocation, big_sur:        "7071ab7aec06d9c8c668e4a6f8ef4e6b3279b3763d160f9878076cdd2d31115d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb847460cb93b9cd3778f101757dc6c47910e9cb843543056f9a01f0447dd375"
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
