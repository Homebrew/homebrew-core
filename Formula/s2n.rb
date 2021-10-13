class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.1.1.tar.gz"
  sha256 "a17ef1e55b0a6c3d422b8b857bcfd26af7d2f8b33628a540854a6c17b8bed4d8"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "69f5f20a7bba16dce6f4a318eef22e04b22966e110cf1953873e746658f7c34d"
    sha256 cellar: :any, big_sur:       "54dcec4b3b4d3d789f672f776488d6268f20ba165e6a59b0a31cfabb41f1fac4"
    sha256 cellar: :any, catalina:      "1995a66e8b86e2675cba1c8246e12c4398afcb825b052eb87716c3968e4ebaec"
    sha256 cellar: :any, mojave:        "5ae985ceb23a932f4fbfcf9aa28ea2ce526c845891ce55a397749fdda73d6f74"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    system "./test"
  end
end
