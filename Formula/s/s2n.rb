class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.4.16.tar.gz"
  sha256 "84fdbaa894c722bf13cac87b8579f494c1c2d66de642e5e6104638fddea76ad9"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c1bf6e3904e20aeac5c157ad1dd5c4e6ba113b3f1242e832780985d1a68f34a4"
    sha256 cellar: :any,                 arm64_ventura:  "33c70eab0c2b476993597ab0881612d11665a018dd85ab59bcfd78ad2294f8e7"
    sha256 cellar: :any,                 arm64_monterey: "fbebd328c511b64a88008960ebc17b940ba24fc6109ea21c82f00464526315b6"
    sha256 cellar: :any,                 sonoma:         "b1e9c18570ce0e28d1ae306bedbc0400c4872fc9d264ab3ca2a21f06fe2f1d7b"
    sha256 cellar: :any,                 ventura:        "a56fc7f59d1b7007c4cee90a9a102352832ada7b2ad7d39df56a0adeef850d86"
    sha256 cellar: :any,                 monterey:       "f1520fe17c662675699e9b4dac7430e1ba5fa889ad8b1be80135dc3f07aa6a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cee84fac40f713957b550dff581bed8158b3f9d74bf6d457b9108955ac64d3a"
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
