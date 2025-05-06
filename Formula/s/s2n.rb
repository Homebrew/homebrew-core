class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.18.tar.gz"
  sha256 "e4a249843d05d239128772da32f875ad9730f8d0cb5a44e8c6802c5882014f79"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a7ebd6cb7bdf1084e2eb48782072e0d5e7b7d0fe35b092e0e369b6ebbf6e3d49"
    sha256 cellar: :any,                 arm64_sonoma:  "48579757109d829850b8217a0a72e4a89ad75d761af3f9b3f78f37aaff05a7ea"
    sha256 cellar: :any,                 arm64_ventura: "612a985dcbf2e456f86a1205f3dcc386226854cf90edb412a5d8cb0a62899c38"
    sha256 cellar: :any,                 sonoma:        "b1f217ddf95412f052afb98c97d531965c40f1b5b6f3e611ab0759ea0d1c86bf"
    sha256 cellar: :any,                 ventura:       "5a9ac5a3fee95ad9c6a02d1cebf202ae845456cdc3169f6e3e36bbd3f726136c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b527db213b143f717dea1364e5367eb7f192662e40bec58d517ff2c9656a9e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1020b198ff56a1aa9293f472d6cda6bdd0533d5255e200174d93ec184ab86347"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
