class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.1.0.tar.gz"
  sha256 "e094fd1f2044cfaeedb534ef1d7e4fd8745d8c07a247ce383cd8a6a5288e195c"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4d73acc318bb6066df036ab0d560a03113cea05b462e2d55e2a0c9998075c5fa"
    sha256 cellar: :any, big_sur:       "9ee273dabac5a86973c870b2c63addc1a3367fbe7875a387a07da24c0a16cebb"
    sha256 cellar: :any, catalina:      "d0476814a16e856e35e25ef05e5a9476f9ffee7d0b6c94c862557cbaa2827527"
    sha256 cellar: :any, mojave:        "c0f8a32cd7be1cc893ef761afae54dbe45d0806ee7ebf435141634b10602bb0c"
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
