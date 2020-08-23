class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.4.0.tar.gz"
  sha256 "e6e9b603caa32c6693cccda8c547b298f3f73867a45e49b33c006cb17b24fa33"
  license "MIT"
  head "https://github.com/odygrd/quill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "28af658907cc0cb9b01675e951afbdf074afbd128a763e5e8d4067869ae9146b" => :catalina
    sha256 "643497902d7e23557b543e45972405765d5f3555a852f82907bf3443ed2c5e24" => :mojave
    sha256 "c46e30954680dde579499619460aff56f8bb495bef0b81f524f3782659634e24" => :high_sierra
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

    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
