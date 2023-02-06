class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "10b8912e4c463a3a86b809076b95bec49aa08393d9ae6b92196cd46314236b87"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c6eb8e14a57948dca8c7d631c3574c6bd93f2e7ca4e4aed50505e7e0b1ec630"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11006f013d25565eda2ef266fd6f3647be5353afa84ed882b743390a54e6a1c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d425470ea29f175ed491ade18626368ea8de92fbf665bab7843fc4c8f0b7b2f0"
    sha256 cellar: :any_skip_relocation, ventura:        "d1f4337c0626eed17ebe924b0d68eecd6b84202071b22a28514111f864076647"
    sha256 cellar: :any_skip_relocation, monterey:       "840e2c33f537f8b27d7308d9bf1aa2895b53d875963e770651bb1468b22015a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4439453849b686a8ad005d56020f8c37e889d011e789eb053e090522b010b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d8ea364a1d55d16860fc3275170e98190a8c8e3e5d6ba97067c685551308b1a"
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
