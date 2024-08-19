class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "5e86d97d8f24653ef3dff3abe6165169f0ba59cdf52b5264987125bba070174d"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8629488a3a0631ab2e8b386e2848552b85282835c01a2227728bc0a6bb1dabb"
    sha256 cellar: :any,                 arm64_ventura:  "4bdddbe7522d1036319c6d4f1c5efd731f7ca6918c9dd2d732abad158fac6a31"
    sha256 cellar: :any,                 arm64_monterey: "10a9813f3b37b3a8c07f0d53968edd636f9a3ec385d34940a73f48b9b79c6623"
    sha256 cellar: :any,                 sonoma:         "e9794bb321dc8261de4c936fe6cc38d30c6c46a0e9457902dcc614e87956dae4"
    sha256 cellar: :any,                 ventura:        "82508215ad9f9842c1b93945c2952025932677d7e487e8e9e971153ad632950b"
    sha256 cellar: :any,                 monterey:       "66ffeb932df535024bb78c46b0bc53c5b2e1ef17571002af35faea6b073c8fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bc0ddb70a8cb28aa5add095f71f6e22d80777a0befa4f5b480ac96ec6a532a6"
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
