class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v2.0.2.tar.gz"
  sha256 "d2dc9004886b787f8357e97d2f2d0c74a460259f7f95d65ab49d060fe34a9b5c"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8b744ecb5a1233b65b32dddabab18eb590d33acf87b48efc35b0e335053877b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b1c6b8750fc26f6ab08829ac1af9aa086ed9982a261d3cadc7d75a71c0759f6"
    sha256 cellar: :any_skip_relocation, monterey:       "fdba38f1697440a409bb1212d71ffa2833a028b94203feb43deb04de2cd26905"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e9da990cc7b87befef6c5def0b7da636eafdd50a950071f6fc94dbaed6a5082"
    sha256 cellar: :any_skip_relocation, catalina:       "dc2fddb4f4e94d466295f53406c577c717650f9491ccc0120d0f62093af192a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cfccb99dd68006151ad0b9d7617c7da85e3d81714dcdaf070080234de8ec03a"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina

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
