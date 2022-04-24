class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.7.1.tar.gz"
  sha256 "9a7a5162727a0b4e2be8f6b15bc3fd2321a32eaceb917a158d7b81cfe284264a"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d18b4275646edb5b944f89aae4b299e426ea16a66b188087232b6309ed4ed5ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa0b80fc91ff5901c629204485a9495c9c6bc51646d24aad97da886abb522ea8"
    sha256 cellar: :any_skip_relocation, monterey:       "b71262ec29faab3250807abb480246801362ea14ef9960e80009a9f53071aa9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a646827641adaead8ec52d2e5a6cb1a57bb9d09a677715769003eba0a399a3c9"
    sha256 cellar: :any_skip_relocation, catalina:       "158b36ca5fc1dc55ccb405d064c15d4df48c2e7a4841e61083397edd92c18234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f915f970460dba40a34b5a87ac80ca97feb85c24e6eaae6c95b93195a632c48e"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

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

    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test", "-pthread"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
