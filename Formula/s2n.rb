class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "15a1d9dc8f498cfd54c3c25aa9c4b4876bb7fdab6b7888968e8eddc3a66eacef"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fb21881aaab55ed1837d3a7973391707b7534813f23e87e5b05ddef84d10e8b3"
    sha256 cellar: :any, big_sur:       "37896bdd5160f98a64b50b6717d5bc5c731a4f71f43262252dde72b730ac65cc"
    sha256 cellar: :any, catalina:      "6e8fb238eb893f2d37d27a664f958e53e9c765cf06677e759ca65edfcc1c518f"
    sha256 cellar: :any, mojave:        "6ba9306cbea7b7538d6fc8fa6cda276611e670d3d3bc807fa36e0e9080a4b60d"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON", "-DBUILD_TESTING=OFF"
      system "make"
      system "make", "install"
    end
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
