class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v2.3.4.tar.gz"
  sha256 "b44d345c07b3023fcd1b88fd9d2554429bb8cccb6285d703d0b0907d9aa85fa1"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62f32deff3c410256dd945d49414f1d26189e8c8d30a4d379add0b867efba979"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88ec791767d1d19fd99d0fe80ab3d408205c120e31b5004b9e3cb6b311fa14f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8772c6e0bd2d1945731c3076d09e7f608c2cc1dc78e033d0962ed3d0f700a13"
    sha256 cellar: :any_skip_relocation, monterey:       "45d10599b983794ce702d1ae942e19c7ea7260c907b2c9e6c0c6cfa6e0ebdeaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0e50faf76c14e943e3b2bec27944e882247cce6324637ade8fd00a7f1ff65c3"
    sha256 cellar: :any_skip_relocation, catalina:       "b01162cde5b3c0c763ab3d38fa606125fc507180f90787da2ebe0ed1745e70a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba0654ea046c69abca079a83826ee382ced39952ee0f8606e1542d9a788316b4"
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
