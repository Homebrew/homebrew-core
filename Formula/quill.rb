class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.3.2.tar.gz"
  sha256 "bf7090c4770cf548d0093499ffb15c0d80c87d74c9bd4cb648f6b6c1e8de35b5"
  head "https://github.com/odygrd/quill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d38c9b0d87a2e817c913fa8d45c29342c7cc31ca942ef0ce8ee7b5e2ddf113c4" => :catalina
    sha256 "19664e186c0f9f01ac54497749166cf3267bdd202531796370bb3739a9d70087" => :mojave
    sha256 "45aa31dee147e09e72987911692af54ae2b0e0025764ded37794941fb23d22c8" => :high_sierra
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
