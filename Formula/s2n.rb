class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.18.tar.gz"
  sha256 "21f4e5c95cf793bb13b0dc51cb11d5936af37ba44ee3cf45a1c6f133b546b5d8"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "502e12d83be1d4958f68a40b22698b5aa5ece1b0c160bb893865e60558a33072"
    sha256 cellar: :any,                 arm64_big_sur:  "2bd5b759f90f48c7d4016116ce05e8fdea6f96a2c89cf20fd1637b3f3b8db803"
    sha256 cellar: :any,                 monterey:       "1c679939d1e185b7e21602fb54c88939cd8198414e70914407be21b51ef98633"
    sha256 cellar: :any,                 big_sur:        "4d36ae70effef2c00c952bf731bd3f79eb1a8a1f51ad9c62eaeb8fc9f989fd38"
    sha256 cellar: :any,                 catalina:       "0d5f96e492da62d9143f9e32887b5596bf23a2aad11e8b11fcc45ab1ac476768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ba1598b41955faecfaeb9485d766594c2008bc4879934dd5352689526fae62"
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
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
