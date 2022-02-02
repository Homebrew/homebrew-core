class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.5.tar.gz"
  sha256 "cbf05cdb38e600e3020d8e6d6e4f5b24b58080b6e43cebf42b3cfe2bb92e4c2a"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "0b53eda24692eb89699b084194be17f57f42f5828b3098b581151d7b6eeafe51"
    sha256 cellar: :any, arm64_big_sur:  "8c3a7da060b574837490ba5aade924d787a1f987bb1677ce84ffb35a0f2b9f17"
    sha256 cellar: :any, monterey:       "f3d3f9e105a5d542a38dfee48ee27885f6a95ef327755965f9fa356693d93ed2"
    sha256 cellar: :any, big_sur:        "c4118f36d58ae5105bc7cf9bb7783fc0826e3353202ee5a47092d6a97d53d769"
    sha256 cellar: :any, catalina:       "0695ea494a99442c1c32d119f7cb3fb440fa45bef237013eaf5099e1e7270b20"
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
