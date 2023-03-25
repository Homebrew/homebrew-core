class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.41.tar.gz"
  sha256 "46d68a57094f2671809d43263996d4ba36457a79e856cbcd721748a7b13c60ab"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9227c7ab25a701640b7a4572643d380e5e3751133e33e1ac915159a5f8d65c19"
    sha256 cellar: :any,                 arm64_monterey: "aab0912603019b4bdaa7bb4cb4ed6ea8c67df81e3028fdee4a44f6ab8a5095e5"
    sha256 cellar: :any,                 arm64_big_sur:  "7e6145f5fa563f462344a1d8d05ce4922003e47a8c93dcd9ae1375c4e906765f"
    sha256 cellar: :any,                 ventura:        "e19778030d50c5240e5d05aeda47ab1d56c3413700b47aa064024aaea6efcb13"
    sha256 cellar: :any,                 monterey:       "cc564e55cbb22070619e4ec3953beb47c31421de22c30ee6e770ed760746621c"
    sha256 cellar: :any,                 big_sur:        "8caf191e5f993de55fc6ca24ff936e551542020c7fe7b7cd29614d0084e39cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aadce9fb8eda980bdae6d3765c3ecd63d1971a0176091f8b66d415cb0002c00"
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
