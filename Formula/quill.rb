class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v2.1.0.tar.gz"
  sha256 "66c59501ad827207e7d4682ccba0f1c33ca215269aa13a388df4d59ca195ee76"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1cc82aa7d85b91e69de1abfa049db94d3e0ee5a89d826fe4b5184b9ea9677dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40ea9265eea1e8daefe213171b1343870adfe15701eed2c63455ebde2fc51dea"
    sha256 cellar: :any_skip_relocation, monterey:       "eb647974436749da7d6c4d7b28dda1ee563ccba93c3ada81c0ab4d7f0e91f9f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6451e2a31e352b52f68d465953dd162c52daae87957cb47d16af6c043a22bc9"
    sha256 cellar: :any_skip_relocation, catalina:       "fb8b121919848c7b0e56e8c6fdcabac2d455c518c5860260c6e24106acb97957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b62d4908f033f0c91343ef7399f1e7b7406c57c155d28b26f1291805a89554b5"
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
