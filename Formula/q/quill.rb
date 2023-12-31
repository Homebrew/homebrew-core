class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "ba9dc3df262f2e65c57904580cc8407eba9a462001340c17bab7ae1dccddb4bd"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45357b7bd9822deaff1c9852c628ea088e31995808a3fe72e03525ea89b7494c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da9ab033ee76f8a08ba6732011402d0de7fa340b614c8c686db57c343bb3d4e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdb091334953b941808e9547128532132d647a38c42ccdbd6def712d5902db7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1901e295faac057bd9350e25dd9ac244e61d9512c1327a502e08ea8ca3f8c73f"
    sha256 cellar: :any_skip_relocation, ventura:        "57afd751c3ff317631b73a2f5c76e9b26cf1532ed675ffe1309557c48b4250cb"
    sha256 cellar: :any_skip_relocation, monterey:       "8f1f0abb334f329374de32f768443045fcdbf0e8753cd56503e2eefc35027568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "772ec4937e7bccbcc6d2ec8cc2abf6db36182ebff3bdd98dd1a14108f7346fb3"
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
