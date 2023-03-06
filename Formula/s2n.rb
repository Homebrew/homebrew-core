class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.38.tar.gz"
  sha256 "6896e68906811a8e0e06bb115573ec907926d5fd90fa03a8c7076b8a8e09916f"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "657dbf4eeb3a21c5901bb70e182d370c08d72bf1800b7258ce59b313e5bb2d07"
    sha256 cellar: :any,                 arm64_monterey: "3f694135e3cd15e453bcfc52914dc88ea5367cfbe732175650247ec1053d74f2"
    sha256 cellar: :any,                 arm64_big_sur:  "393c1d3c9d4549f646882166f21dbc582d6b6d4f0850f34e96b804da0f6c419a"
    sha256 cellar: :any,                 ventura:        "01c710d9df77bcb271ca90c12e3d542b3bbea81676105d71dfce29e0e8f3f1ff"
    sha256 cellar: :any,                 monterey:       "fd87bb4413d97de0c7c9a0096f96e78f608b8a4757e9705e71eb2bdd00321598"
    sha256 cellar: :any,                 big_sur:        "27f689aec905658b29bc36cd886f8a1ce34eaa8fe915cdafb57c74140fa979e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6fe2b0872ec750d9f68cd0bbb2a467fde463dca2ec31703b23f56d2dfbef765"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
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
