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
    sha256 cellar: :any, arm64_big_sur: "5adc2344c1c109dda1fa466f0734e6b39abef615789d32332bea5a3a17e2d20f"
    sha256 cellar: :any, big_sur:       "27b11c4ad14d2fab9eb837c33facf1d3a30bc85b4ef87268f924da6b9f3c940b"
    sha256 cellar: :any, catalina:      "724b42f554c283c057ca973e90a0c9384988e9ab170a755d32cc3f64135d6b8a"
    sha256 cellar: :any, mojave:        "94db1a6ba997ab639a2a15b4a22af8f44212b5fb253142ad253fff11e20b59c8"
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
