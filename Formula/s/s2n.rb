class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.54.tar.gz"
  sha256 "8d6ba5c961142902f99a3c16c9d85132b6aa765f2c7196047152296b3d37e63d"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "da6e8da144015fec16a4539eb2934444a064bca681a9a40ba6c0c24bbac4e498"
    sha256 cellar: :any,                 arm64_ventura:  "76abf5e2cd26c122b73c40f20f6ac56527044430c13f3142bd060837ac279d08"
    sha256 cellar: :any,                 arm64_monterey: "83562e4bff0bac3c6c731fc4f02e24ee1757a267db4179acce4bc891e597d153"
    sha256 cellar: :any,                 sonoma:         "957f464db4690a1d79cce1a430e8993c8344abcd1e1e0d4f4a808b69e672e19d"
    sha256 cellar: :any,                 ventura:        "9918e0fd0413d652960ff4a82da640364f2c9524a91265d3b019434dfd50cc17"
    sha256 cellar: :any,                 monterey:       "a06763c57332da502cd3d35219c14da54adee0d2881f2bef62fa3ab747db2dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bbda361d560860145c3b09df32ac609e8f7838d9eaaf71e5362d7a3f6ca87fc"
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
