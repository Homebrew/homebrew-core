class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.3.tar.gz"
  sha256 "6c562dafa9f54ebc75df3f386c83b9a2de0da8a34bcb8fe58e22c7c2436fefff"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "b9d30c6fba9e64d945d929ea7c5066e5886a9c793d2a1435d9e4c37af19ecdce"
    sha256 cellar: :any, arm64_big_sur:  "cccb900516e037fe849efcc69687fd248d9812dc0c729b34ebf7ce9fafbe9e61"
    sha256 cellar: :any, monterey:       "7c8f57cf94196fec458dae37312129813713068dd51c42d4f0e7e0c9abd11b3a"
    sha256 cellar: :any, big_sur:        "c2acb4b9612e40976fdd5d5faf48a596e818586c197f96b5f02e2161ea342f03"
    sha256 cellar: :any, catalina:       "3221ba32de39b4bcef29d898aae16a31a82103a457c66764613fc769dddf46a3"
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
