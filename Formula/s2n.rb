class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.28.tar.gz"
  sha256 "51000747bece77f35df88b2a4157c0caf16e6a092ab6dc71cd6880bf47afa169"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cc920cc35329daa40c1db991d585047584c2b1fe0421e5f864fee60e94e581f9"
    sha256 cellar: :any,                 arm64_monterey: "fd8d0fb9475239473397b2c3f43f30d1b03c0b5b1abef11236d1a78927c15c4e"
    sha256 cellar: :any,                 arm64_big_sur:  "044e4839395939888bb13b06d8e7c3f43260e34b759643de6d649efd64d52efc"
    sha256 cellar: :any,                 ventura:        "0fe984dbf0e42fc60ebf712b1e7da5e3d3a5ae93dccdb948c5f1ae9aaae8562e"
    sha256 cellar: :any,                 monterey:       "efcc094a149f637e298d37802255fff72575baa04ef15df600b301a7f8e6aa0f"
    sha256 cellar: :any,                 big_sur:        "9d1075067587fa1e0be980a38f95a13e70848937b7b3ebd8cbe29ab50e9d99f6"
    sha256 cellar: :any,                 catalina:       "a94bce7eb76d0d4ea38112ff313d37dae79648df0090ca62e63ff3d0475d06e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a69490eea3c84228fef454a436369381a1cfb703942f779dcda5f03018049418"
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
