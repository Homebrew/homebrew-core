class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "b90baecf64a6dd2bd708db9dd7f51e914bc17b84dec0fb799188a7712df60a10"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "59262e65f16441cc37c356cbc65df4eebd852ef19155a32c0b33e4db36bfc20a"
    sha256 cellar: :any,                 arm64_ventura:  "dbaf1279361420d5a019e1c3376eb3fd69a8a911d8f04b4d86613a4dcbdfd23f"
    sha256 cellar: :any,                 arm64_monterey: "6909e962a70f7c491a318cd27871cdf35f51df16c9480eabc73b71d887fc4c46"
    sha256 cellar: :any,                 sonoma:         "aaa76b8cbaf1f18681b9a3ab77a2ad2b77f399f2dddcb28b4ffd4a390364bfaf"
    sha256 cellar: :any,                 ventura:        "585474046cbdda3af2330822ebc7cdf7f9dc72e2634b2110223621733771c436"
    sha256 cellar: :any,                 monterey:       "5bf4f2c741e1a990f7a1dd00dc800f3fb90fb65aa94dbbbdb6715059e42efcb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c613695010fe8d562f17725276308a087c8f79784b8ee02dfbaab2dfdfa92c0"
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
