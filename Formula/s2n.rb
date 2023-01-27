class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.34.tar.gz"
  sha256 "c5ed216251f2ed33a7b1e61a9ab5555493d0c33fd1de3baa74e33c8b1d6b6818"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0cf73757497095bbae9dbd13ede2efb44aecd3aadde2bb13d218db4ceefd9acb"
    sha256 cellar: :any,                 arm64_monterey: "468fc99358c1ef625f0eaedb080557eb62d75af7e98cfab90a791c4a6d0878a0"
    sha256 cellar: :any,                 arm64_big_sur:  "47e8d875bfbcaf2a6fc0dc7cceaf494457ad5ba74b2b2bc53179a4df72bb31e6"
    sha256 cellar: :any,                 ventura:        "ca268b7a94b53b7a62b2045131f7d11a3c97df1955b60032454e12a7b1321cf3"
    sha256 cellar: :any,                 monterey:       "3e1803ea7dc43980f92e9ae34c74f72598f0e8084b08c93dd88b7ae94476a235"
    sha256 cellar: :any,                 big_sur:        "07d5e17e769071475f2025a701d14c0918bb2d4b8844bf00b6b40edc81174cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4506422550d084127d27b18a523b6c71390ebc48d9a0f7f8fbe61074a6267f64"
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
