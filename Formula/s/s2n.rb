class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://aws.github.io/s2n-tls/usage-guide/"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "90ec7934af222b0f58f1143dabe12358489f628956ec25fa1bf752b2a33bfd5a"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c76a259d77028c97de0da7a273b49c5894adc96dec4f60111b9ffdffa2911e4a"
    sha256 cellar: :any, arm64_sequoia: "ae667d5858de869ada2f367a47b9812f039e02a62f67c9c50a4835dfbca566b3"
    sha256 cellar: :any, arm64_sonoma:  "add656efcbe5073eef4b197f524a60831b63bc50a81561270b58f05e0aa4f84e"
    sha256 cellar: :any, sonoma:        "66e250bfb6f3a880b5909f9d6080686669ab485a5b547d6da59cb58961ae206f"
    sha256 cellar: :any, arm64_linux:   "fc3c04ea9546968d88507d5a61b83956a95dfd5507cb266f783a78ce0e86e2c8"
    sha256 cellar: :any, x86_64_linux:  "631ffb711333661e42d43b4e4d89b2bb20ba78c2d00499786fb838364684ce66"
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
