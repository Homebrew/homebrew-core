class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "53afe555c32b4263c9d31ec11bd0d858983374af7a5e79eb26124f803b192515"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f27fbfd4ba87284fc3161f770292dba7cd01682326a5541e0436d2c118eb56af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2bd4bac911e38944270668b8b65b065f3d43e89be4a02e8ae9553e61c3010d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaf5f83336a84a22352d3338d6fa8dc16d2ff0ec78450e27f7c97b44f7f2324a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5913fa086c45b7a772c7d6e04ccbf5d899a21e9bf440cc7cf7be07cfb2ba0096"
    sha256 cellar: :any_skip_relocation, ventura:        "f9377d10a37b9fef1d7bbee9648b24dd6d22736a0c7c0dee7772647b44ad1579"
    sha256 cellar: :any_skip_relocation, monterey:       "f9234d5c08ed914de1c66aabc9b1c27f5c9633f537f399266e3447132d377f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "786f3fa6c56f20fc34e864a3823e9cc92046e7d53587c7d31eaca539d6f28bbe"
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
