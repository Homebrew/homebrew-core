class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.2.tar.gz"
  sha256 "9a43f97cc3c751c19a03fb6e07eea10e1452034c20a3656a333c3d068756a888"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "f5e7b37bca1cedb55528a5679fe34a2dd0caf94e16420012e1be0a9366311d8f"
    sha256 cellar: :any, arm64_big_sur:  "4e14aa16cacdbbe940429d3fc3c85f80efe325e2d34ab64b8d8a997a4d34d859"
    sha256 cellar: :any, monterey:       "57bde97b3820f21bb1c8d6cb2f0e599ba3d8b46b6ea72e05a66115d120c132a0"
    sha256 cellar: :any, big_sur:        "1762489a66640017447e62f7fd7cbdd1e32f66a844a963b532be936c22129d84"
    sha256 cellar: :any, catalina:       "989d2bbeac5fd6d4d32c7d071a2966561ab71654dc17956cf0e2002270802a61"
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
