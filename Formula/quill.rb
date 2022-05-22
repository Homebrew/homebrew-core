class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v2.0.1.tar.gz"
  sha256 "39527aca74edd02d9df0bba62211df9f6d53984d4f6cca470734e19c4d8b69fb"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad91dc0a18ed1ef72579673bac7f3e25411a201afeef90263ac0387e7a434bd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c92d8677d14df3b3d3d434df75a85a1d0173f58aab80d294a9289aa75096e03"
    sha256 cellar: :any_skip_relocation, monterey:       "ac1cc162b5593617baa2049995f79bc8d2a71cd732142ad7c01d48c3810410d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a9f2307ecfcf1e1939fb5cae56844ce80fa3533f6c9ff528f8de60090e8ec25"
    sha256 cellar: :any_skip_relocation, catalina:       "8e309ce6ce55b912e3bcb351691b4c4e855d21dda735e32a4eb139cd753c1f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b28feaff791727090393656f2057958412597b2ab827bc8e9d468cb6929b9c8"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

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
