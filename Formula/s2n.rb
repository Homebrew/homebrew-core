class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.0.18.tar.gz"
  sha256 "74a01db4dec9ddec8fb17de98c8d47add6b6998fe512aed462ffd871691baa32"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "27dbdbcb0fd105f64749cccd2a0284a8bd706e8c2ccff25814151a438aa16e9d"
    sha256 cellar: :any, big_sur:       "5a37830132af8966a6032d227a69b098f1995104ec3babe8853f7ccf7f6ce7e5"
    sha256 cellar: :any, catalina:      "b629343d6c9ffd1ee408f5f439dc548cc6951b30f301ed3acd059cbd39810210"
    sha256 cellar: :any, mojave:        "4d95a1ccfb5515713498e4a08cf6ac0fd195f51e887cf2e3403170fafb7697e1"
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
