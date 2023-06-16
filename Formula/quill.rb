class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "005e92f7824aa35aa0ff8d4a2af7b8af15703d7adfcd1985777e0a01d585472a"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46217ada5e7ff7141e63a01f2371d04c5761a92594290c2d098a6d7aab64c813"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09f4e8e0b504af8151a5f60c0dbad0fb7bf9fdc625d18e4b596c411642a42bd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bebde3ba8cd3c8ff6d221034084d9044edf5fc477f4349bf63120cf71e7c87d"
    sha256 cellar: :any_skip_relocation, ventura:        "f9c1b5057aa11eb1137842f1972e147e47c830ba2a1f4d15c44d91ed18ce306d"
    sha256 cellar: :any_skip_relocation, monterey:       "fe72e852d9b7b41a88962f9a18c393397b0f887d677814de50e05be1830ae15c"
    sha256 cellar: :any_skip_relocation, big_sur:        "efa326590e09b24e3c6cf762ac4452bfc404afe6c120bb5cacff001fe4290d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a12717112b9b93be8d3d14d09cf6878eeba1f5a6b9714ec99e34010e670109a"
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
