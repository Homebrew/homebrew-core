class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "d3e1b349c5d6904c9644e5b79ec65f21692e8094a3d75241a7fe071076eef4dd"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f448d443209b37ab355d6bc7339ff75a58cbd796960719f70adbc158c1c5cbee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7343b2c8d72e8e196536a0088d8c43caa0e34e8f6d31190b763bfcc4070130b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "131adfac21440860344dfdbb24ef2f63a35a5e87528beb878cc57ae3d3175a4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e298f8e47eb9b47deb3edb4f51d95a6f422b2feb48fbeddcae6ffebeac03c4ba"
    sha256 cellar: :any_skip_relocation, ventura:        "79bb6416dc9b4f8179a95cc923f045145deffa75686135748a9128f8e23afa75"
    sha256 cellar: :any_skip_relocation, monterey:       "daf701c729283b86dce79b3d62b48322b11c9596728df1f2fba648ab1b5b7d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfa8568c929b7bf2f9b2e5131ac0e965c5ae56012c51b5f50aff7ca9e87ac486"
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
