class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "0461a6c314e3d882f3b9ada487ef1bf558925272509ee41a9fd25f7776db6075"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99bea4bded36ab57bf49acc8c8f4ca6d9edd1f696ceedcf753313b3f41bc21a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bd2bf86fe0720d83915ffaf55c3fd9261b784a9b6a50065dc632bfd3c172ee1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e16a551ccfc4c193ce7b58ef34cf791f27903b2e31337aaf907fb281ad514314"
    sha256 cellar: :any_skip_relocation, ventura:        "084ec31959f128529179bd7b56199de657225c24a269be7747bcf34d6ddcf324"
    sha256 cellar: :any_skip_relocation, monterey:       "a67514752fb88b59ef8c0976d15fa0f985c7af33e09094658b26cf58d0ff30bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cf0c875a39e26b2945f2bf13632a2f32584aa890ad7f197385c736447065c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50cc80d203cb7f2e3d2dab58c02ed79f1ef30e5f1b9094500d66af70c766254b"
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
