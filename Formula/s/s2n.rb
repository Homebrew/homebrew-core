class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "6316e1ad2c8ef5807519758bb159d314b9fef31d79ae27bc8f809104b978bb04"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5d574f4c48df323b23a91250bde069975509888e3f43a14ceda06ce798f153fc"
    sha256 cellar: :any,                 arm64_sonoma:  "f7088e01dd091f1ae089977bdd411c03c59ba37d64c014851e792df61be093ec"
    sha256 cellar: :any,                 arm64_ventura: "02f01fa5c5c2aa8ab102fe29e8038b2a1853a77fa8a965b588b832414e098f06"
    sha256 cellar: :any,                 sonoma:        "ba4ce101f78aea26f3bbfa7fa796f60b539ba7e005b34627d577b5246fd0a25c"
    sha256 cellar: :any,                 ventura:       "c1711affcdcc0655d40a7775cc8c0fdd481d9e3c31b00429192a9aeb6461aabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "059745ac392e2dafa1544db6707e8a338000fa106c913136649fd2a28bb70bfa"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  conflicts_with "aws-sdk-cpp", because: "both install s2n/unstable/crl.h"

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
