class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "62227595cc2b4c0c42ed35f17ef5b7487d8231aca9e75234a4c0e346cea19928"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82896bbb40112bf0c22598bdc8b221a220e66d591645488baf5535f6efc359d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1e1621fa59caed357c80faf614650e26cf6b074ddd5204484d71c4df058aa2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f551eb45b42bc7c38a80a3e4feaf7fd2a4b599f4c7a1fb115f5ff3b3ee6267f"
    sha256 cellar: :any_skip_relocation, ventura:        "aec125d7b661c5afa326f939fc75e255d26648d2fa729531e6b52dc0def4e9e8"
    sha256 cellar: :any_skip_relocation, monterey:       "80f2ea22f760e47d9626766016df33698fbbc4a731a5a7fa50bd638be16c2a27"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c9ca15db2420e41e2f200cb5547700c0dc9a8626b27a86ea8df5383a1823ea2"
    sha256 cellar: :any_skip_relocation, catalina:       "5234c1b07dae4fb52c96c5985dbe017ebcc450bf2305f203f223b4ece5b8b05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "562465d10bff5dd4e4568cb865b42be3686294d2a2f6cab03b75e95fb6165bbd"
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
