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
    sha256 cellar: :any, arm64_monterey: "5d36a6e0438877da71759e145e224f1a23d986f778aba02371c32f9125a40f0c"
    sha256 cellar: :any, arm64_big_sur:  "78bd32fb5dfcc75ff498b8d8d1b3f79cfa7b11f7ea97db69a5fdc05735352ead"
    sha256 cellar: :any, monterey:       "09b51bc6a248652cdec42ea9c36578495d5ff188ceb369305067348aca5301fa"
    sha256 cellar: :any, big_sur:        "8fc0a110847081e0bf50d51bb681165ce5e6dbf6b51f3331522b7d6e9f45d783"
    sha256 cellar: :any, catalina:       "4be47f16f5cb431948176145112a92df693debcc76051022774d9db3086db423"
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
