class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.0.17.tar.gz"
  sha256 "e548c1208205a8959c68f8389eac721fc37fc99d3600790430783972272c9452"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8b4e0642da6e067afbef7ad3b289deecec21dd4004759096f54bd492b64e1105"
    sha256 cellar: :any, big_sur:       "3e0d69e2555ff6270526fa58858be774578f82f87a93d28dea2a92d6e320a7b1"
    sha256 cellar: :any, catalina:      "33a4d0c27f19a5178061f8692e95d5a432286a7be2113de5ea29e9ceacbf4ec0"
    sha256 cellar: :any, mojave:        "3b883ac5a98371b8638b37b1b49e50269b852af34d523310f926e412e2f7c44a"
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
