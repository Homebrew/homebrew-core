class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "4771dc08c0ff01cea9081d645ed7cae27cfa073185c986177ef3ce13743136af"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44f81cd0d1c903a303c84413dea086c7e9bccec2dba13f14d9f4a0f4cf26a8ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6afc375f833a37284a9959389afa325c8b0379464f1864fa812b0b5e06edd58c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63362f8768f9e58184d96dd291306788f37cd355876dea0052eb14af07f36d24"
    sha256 cellar: :any_skip_relocation, monterey:       "4f38bf807f3c0135d1f18b4d39207d56e1395007b1d5f1ac64ba00289d0eb812"
    sha256 cellar: :any_skip_relocation, big_sur:        "4903830c3df0986e8b6dbcf74a298f651e1816aea0a5bfea6cc33b574d8241f4"
    sha256 cellar: :any_skip_relocation, catalina:       "64796367dae59feb306942d740a68927503db4f6014e4e5f78c27246498a0960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "278136cb6abf20a0d69ee6d11b8a5d6d80528b2d051d3c50ab0afb1447a7cc5b"
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
